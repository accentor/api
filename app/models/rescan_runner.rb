# == Schema Information
#
# Table name: rescan_runners
#
#  id           :bigint           not null, primary key
#  error_text   :text
#  finished_at  :datetime         not null
#  processed    :integer          default(0), not null
#  running      :boolean          default(FALSE), not null
#  warning_text :text
#

class RescanRunner < ApplicationRecord
  def self.instance
    RescanRunner.first || RescanRunner.create
  end

  def schedule
    delay(queue: :rescans).run
  end

  def run
    # rubocop:disable Rails/SkipsModelValidations
    # RescanRunner doesn't have validations, and we need to use update_all to use it's atomicity
    return if RescanRunner.where(id: id, running: false).update_all(running: true, processed: 0, warning_text: '', error_text: '').zero?

    # rubocop:enable Rails/SkipsModelValidations

    # We updated this instance in a round-about way
    reload

    begin
      unless Location.count.positive?
        update(error_text: 'No locations defined')
        return
      end

      unless Codec.count.positive?
        update(error_text: 'No codecs defined')
        return
      end

      Location.all.find_each do |l|
        process_all_files(l, l.path)
      end

      AudioFile.find_each do |af|
        update(warning_text: "#{warning_text}File #{af.full_path} doesn't exist anymore.\n") unless af.check_self
      end
    rescue StandardError => e
      backtrace = Rails.env.production? ? e.backtrace.first(5).join("\n") : e.backtrace.join("\n")
      update(error_text: "#{error_text}A really unexpected error occurred while processing: #{e.message}\n#{backtrace}\n")
    ensure
      update(running: false, finished_at: DateTime.current)
    end
  end

  private

  def process_all_files(location, path)
    unless File.directory?(path)
      update(error_text: "#{error_text}#{path} (in #{location.path} is not a directory\n")
      return
    end

    Dir.each_child(path) do |child|
      if File.directory?(File.join(path, child))
        process_all_files(location, File.join(path, child))
      else
        Codec.all.find_each do |c|
          next unless File.extname(child)[1..]&.downcase == c.extension.downcase.to_s

          begin
            process_file(location, c, File.join(path, child))
            update(processed: processed + 1)
          rescue StandardError => e
            backtrace = Rails.env.production? ? e.backtrace.first(5).join("\n") : e.backtrace.join("\n")
            update(error_text: "#{error_text}An error occurred while processing #{File.join(path, child)}: #{e.message}\n#{backtrace}")
          end
        end
      end
    end
  end

  def process_file(location, codec, path)
    relative_path = Pathname.new(path).relative_path_from(Pathname.new(location.path))

    return if AudioFile.exists?(location: location, filename: relative_path.to_s)

    tag = WahWah.open(path)
    t_artist = tag.artist&.unicode_normalize
    t_albumartist = tag.albumartist.present? ? tag.albumartist&.unicode_normalize : t_artist
    t_composer = tag.composer&.unicode_normalize
    t_title = tag.title&.unicode_normalize
    t_number = tag.track || 0
    t_album = tag.album&.unicode_normalize
    t_year = convert_year(tag.year)
    t_genre = tag.genre&.unicode_normalize
    length = tag.duration
    bitrate = tag.bitrate || 0
    sample_rate = tag.sample_rate || 0
    bit_depth = tag.bit_depth || 0

    unless t_artist.present? && t_title.present? && t_album.present?
      update(error_text: "#{error_text}File #{path} is missing required tags (album, artist, title)\n")
      return
    end

    albumartist = Artist.find_by(name: t_albumartist) || Artist.new(name: t_albumartist, review_comment: 'New artist')
    albumartists = if t_albumartist.downcase == 'various artists'
                     []
                   else
                     [AlbumArtist.new(artist: albumartist,
                                      name: t_albumartist,
                                      order: 1,
                                      separator: nil)]
                   end

    album = Album.find_by(title: t_album, release: t_year) ||
            Album.new(title: t_album,
                      release: t_year,
                      image: find_image(Pathname.new(path).parent),
                      review_comment: 'New album',
                      album_artists: albumartists)

    audio_file = AudioFile.new(location: location, codec: codec, filename: relative_path.to_s, length: length, bitrate: bitrate, sample_rate: sample_rate, bit_depth: bit_depth)

    artist = if t_albumartist == t_artist
               albumartist
             else
               Artist.find_by(name: t_artist) || Artist.new(name: t_artist, review_comment: 'New artist')
             end
    track_artists = [{
      artist: artist,
      name: t_artist,
      role: :main,
      order: 1
    }]
    if t_composer.present?
      composer = Artist.find_by(name: t_composer) || Artist.new(name: t_composer, review_comment: 'New artist')
      track_artists << {
        artist: composer,
        name: t_composer,
        role: :composer,
        order: 2
      }
    end

    track_artists = track_artists.map { |ta| TrackArtist.new(artist: ta[:artist], name: ta[:name], role: ta[:role], order: ta[:order]) }

    genre = (Genre.find_by(normalized_name: Genre.normalize(t_genre)) || Genre.new(name: t_genre) if t_genre.present?)
    genres = genre.present? ? [genre] : []

    track = Track.new(title: t_title,
                      number: t_number,
                      track_artists: track_artists,
                      genres: genres,
                      audio_file: audio_file,
                      album: album,
                      review_comment: 'New track')
    track.save
  end

  def find_image(path)
    cover_info = find_cover path
    return if cover_info.blank?

    Image.new(image_type: cover_info[0],
              image: { io: File.open(cover_info[1]),
                       filename: File.basename(cover_info[1]),
                       content_type: cover_info[0].mimetype })
  end

  def find_cover(path)
    CoverFilename.all.find_each do |cf|
      ImageType.all.find_each do |it|
        Dir.entries(path).each do |f|
          return [it, File.join(path, f)] if f.downcase == "#{cf.filename.downcase}.#{it.extension.downcase}"
        end
      end
    end
    nil
  end

  def convert_year(tag)
    return Date.new(0) unless tag # WahWah returns nil if the file doesn't have a date tag

    date = tag.split('-').map(&:to_i)
    Date.new(date[0], date[1] || 1, date[2] || 1)
  rescue Date::Error
    Date.new(0)
  end
end
