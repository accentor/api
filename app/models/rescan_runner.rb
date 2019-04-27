# == Schema Information
#
# Table name: rescan_runners
#
#  id           :bigint(8)        not null, primary key
#  warning_text :text
#  error_text   :text
#  processed    :integer          default(0), not null
#  running      :boolean          default(FALSE), not null
#

class RescanRunner < ApplicationRecord
  def run
    return if RescanRunner.where(id: id, running: false).update_all(running: true, processed: 0, warning_text: "", error_text: "").zero?

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

      Location.all.each do |l|
        process_all_files(l, l.path)
      end

      AudioFile.find_each do |af|
        update(warning_text: "#{warning_text}File #{af.full_path} doesn't exist anymore.\n") unless af.check_self
      end
    rescue Exception => e
      update(error_text: "#{error_text}A really unexpected error occurred while processing: #{e.message}\n#{e.backtrace.join("\n")}\n")
    ensure
      update(running: false)
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
        Codec.all.each do |c|
          if File.extname(child).downcase == ".#{c.extension.downcase}"
            begin
              process_file(location, c, File.join(path, child))
              update(processed: processed + 1)
            rescue Exception => e
              update(error_text: "#{error_text}An error occurred while processing #{File.join(path, child)}: #{e.message}\n#{e.backtrace.join("\n")}\n")
            end
          end
        end
      end
    end
  end

  def process_file(location, codec, path)
    relative_path = Pathname.new(path).relative_path_from(Pathname.new(location.path))

    return if AudioFile.where(location: location, filename: relative_path.to_s).exists?

    EasyTag.open(path) do |tags|
      t_artist = tags.artist&.unicode_normalize
      t_albumartist = (tags.album_artist || t_artist)&.unicode_normalize
      t_composer = tags.composer&.unicode_normalize
      t_title = tags.title&.unicode_normalize
      t_number = tags.track_number
      t_album = tags.album&.unicode_normalize
      t_year = tags.year
      t_genre = tags.genre&.unicode_normalize
      length = tags.length
      bitrate = tags.bitrate

      unless t_artist.present? && t_title.present? && t_album.present?
        update(error_text: "#{error_text}File #{path} is missing required tags (album, artist, title)\n")
        return
      end

      albumartist = Artist.find_by(name: t_albumartist) || Artist.new(name: t_albumartist, review_comment: 'New artist')

      album = Album.find_by(title: t_album, release: Date.ordinal(t_year)) ||
          Album.new(title: t_album,
                    release: Date.ordinal(t_year),
                    image: find_image(Pathname.new(path).parent),
                    review_comment: "New album",
                    album_artist: [AlbumArtist.new(artist: albumartist, name: t_albumartist, order: 0)])
      audio_file = AudioFile.new(location: location, codec: codec, filename: relative_path.to_s, length: length, bitrate: bitrate)

      artist = if t_albumartist == t_artist
                 albumartist
               else
                 Artist.find_by(name: t_artist) || Artist.new(name: t_artist, review_comment: "New artist")
               end
      track_artists = [{
                           artist: artist,
                           name: t_artist,
                           role: :main,
                           order: 0
                       }]
      if t_composer.present? && t_composer != t_artist
        composer = Artist.find_by(name: t_composer) || Artist.new(name: t_composer, review_comment: "New artist")
        track_artists << {
            artist: composer,
            name: t_composer,
            role: :composer,
            order: 1
        }
      end

      track_artists = track_artists.map {|ta| TrackArtist.new(artist: ta[:artist], name: ta[:name], role: ta[:role], order: ta[:order])}

      genre = if t_genre.present?
                Genre.find_by(name: t_genre) || Genre.new(name: t_genre)
              end
      genres = genre.present? ? [genre] : []

      track = Track.new(title: t_title,
                        number: t_number,
                        track_artists: track_artists,
                        genres: genres,
                        audio_file: audio_file,
                        album: album,
                        review_comment: "New track")
      track.save
    end


  end

  def find_image(path)
    cover_info = find_cover path
    if cover_info.present?
      Image.new(image_type: cover_info[0],
                image: {io: File.open(cover_info[1]),
                        filename: File.basename(cover_info[1]),
                        content_type: cover_info[0].mimetype})
    end
  end

  def find_cover(path)
    CoverFilename.all.each do |cf|
      ImageType.all.each do |it|
        Dir.entries(path).each do |f|
          if f.downcase == "#{cf.filename.downcase}.#{it.extension.downcase}"
            return [it, File.join(path, f)]
          end
        end
      end
    end
    nil
  end
end
