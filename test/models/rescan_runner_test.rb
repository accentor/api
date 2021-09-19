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
#  location_id  :bigint           not null
#
require 'test_helper'

class RescanRunnerTest < ActiveSupport::TestCase
  setup do
    @runner = create(:rescan_runner)
    Codec.create(extension: 'flac', mimetype: 'audio/flac')
    Codec.create(extension: 'mp3', mimetype: 'audio/mpeg')
    ImageType.create(extension: 'png', mimetype: 'image/png')
    ImageType.create(extension: 'jpg', mimetype: 'image/png')
    CoverFilename.create(filename: 'image')

    # We want to test whether jobs are created, so do want these jobs to be created
    Delayed::Worker.delay_jobs = true
  end

  test 'schedule should create a task' do
    assert_difference('Delayed::Job.count') do
      @runner.schedule
    end
  end

  test 'should not schedule a second task if running' do
    @runner.update(running: true)
    assert_no_difference('Delayed::Job.count') do
      @runner.schedule
    end
  end

  test 'schedule_all should create one task per runner' do
    3.times { create(:rescan_runner) }

    assert_difference('Delayed::Job.count', RescanRunner.count) do
      RescanRunner.schedule_all
    end
  end

  test 'should complain when there are no codecs' do
    @runner.location.update(path: Rails.root.join('test/files/success-one-file'))
    Codec.destroy_all

    @runner.send(:run)
    @runner.reload

    assert_not @runner.error_text.empty?
    assert_equal 0, @runner.processed
    assert_not @runner.running
  end

  test "should complain when location doesn't exist" do
    @runner.location.update(path: Rails.root.join('test/files/doesnt-exist'))

    @runner.send(:run)
    @runner.reload

    assert_not @runner.error_text.empty?
    assert_equal 0, @runner.processed
    assert_not @runner.running
  end

  test 'should complain when location is a file' do
    @runner.location.update(path: Rails.root.join('test/files/base.flac'))

    @runner.send(:run)
    @runner.reload

    assert_not @runner.error_text.empty?
    assert_equal 0, @runner.processed
    assert_not @runner.running
  end

  test 'should be able to read a file successfully' do
    @runner.location.update(path: Rails.root.join('test/files/success-one-file'))

    @runner.send(:run)
    @runner.reload

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 3, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal %w[artist composer], Track.first.artists.map(&:name).sort
    assert_equal 'album', Album.first.title
    assert_equal 'albumartist', Album.first.artists.first.name
    assert_equal 1970, Album.first.release.year
    assert_equal 'genre', Genre.first.name
  end

  test 'should reuse artist if artist and composer are equal' do
    Location.create(path: Rails.root.join('test/files/success-same-artist-composer'))

    @runner.run
    @runner.reload

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 2, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal %w[artist artist], Track.first.artists.map(&:name).sort
    assert_equal 'album', Album.first.title
    assert_equal 'albumartist', Album.first.artists.first.name
    assert_equal 1970, Album.first.release.year
    assert_equal 'genre', Genre.first.name
  end

  test 'should be able to read a file from a nested directory successfully' do
    @runner.location.update(path: Rails.root.join('test/files/success-nested'))

    @runner.send(:run)
    @runner.reload
    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 3, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal %w[artist composer], Track.first.artists.map(&:name).sort
    assert_equal 'album', Album.first.title
    assert_equal 'albumartist', Album.first.artists.first.name
    assert_equal Date.new(1970, 1, 1), Album.first.release
    assert_equal 'genre', Genre.first.name
  end

  test 'should be able to recover from catastrophic error' do
    Codec.stubs(:all).raises('Catastrophic error')

    @runner.send(:run)
    @runner.reload
    assert_not @runner.error_text.empty?
    assert_includes @runner.error_text, 'Catastrophic error'
    assert_equal 0, @runner.processed
    assert_not @runner.running
  end

  test 'should be able to recover from bad files and proceed' do
    @runner.location.update(path: Rails.root.join('test/files/failure-bad-file'))
    # Make sure bad file is processed before good file
    Dir.stubs(:each_child).multiple_yields('empty.flac', 'all-tags.mp3')

    @runner.send(:run)
    @runner.reload

    assert_not @runner.error_text.empty?
    assert_includes @runner.error_text, 'empty.flac'
    assert_equal 1, @runner.processed
    assert_not @runner.running
  end

  test 'should not do anything if runner is already running' do
    @runner.location.update(path: Rails.root.join('test/files/success-one-file'))

    @runner.update(running: true, warning_text: 'unchanged', error_text: 'unchanged', processed: 64)
    @runner.send(:run)
    @runner.reload
    assert_equal 'unchanged', @runner.error_text
    assert_equal 'unchanged', @runner.warning_text
    assert_equal 64, @runner.processed
    assert @runner.running
  end

  test 'artist tag should be required' do
    @runner.location.update(path: Rails.root.join('test/files/failure-no-artist'))

    @runner.send(:run)
    @runner.reload
    assert_not @runner.error_text.empty?
    assert_includes @runner.error_text, 'no-artist.mp3'
    assert_equal 1, @runner.processed
    assert_not @runner.running
  end

  test 'album tag should be required' do
    @runner.location.update(path: Rails.root.join('test/files/failure-no-album'))

    @runner.send(:run)
    @runner.reload
    assert_not @runner.error_text.empty?
    assert_includes @runner.error_text, 'no-album.mp3'
    assert_equal 1, @runner.processed
    assert_not @runner.running
  end

  test 'title tag should be required' do
    @runner.location.update(path: Rails.root.join('test/files/failure-no-title'))

    @runner.send(:run)
    @runner.reload
    assert_not @runner.error_text.empty?
    assert_includes @runner.error_text, 'no-title.mp3'
    assert_equal 1, @runner.processed
    assert_not @runner.running
  end

  test 'album artists should be empty if albumartist tag is Various Artists' do
    @runner.location.update(path: Rails.root.join('test/files/success-various-artists'))

    @runner.send(:run)
    @runner.reload

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 2, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal %w[artist composer], Track.first.artists.map(&:name).sort
    assert_equal 'album', Album.first.title
    assert_equal 0, Album.first.artists.count
    assert_equal Date.new(1970, 1, 1), Album.first.release
    assert_equal 'genre', Genre.first.name
  end

  test 'album artists should fall back to artist if albumartist tag is empty string' do
    @runner.location.update(path: Rails.root.join('test/files/success-empty-albumartist'))

    @runner.send(:run)
    @runner.reload

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 1, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal %w[artist], Track.first.artists.map(&:name)
    assert_equal 'album', Album.first.title
    assert_equal %w[artist], Album.first.artists.map(&:name)
    assert_equal Date.new(1970, 1, 1), Album.first.release
    assert_equal 'genre', Genre.first.name
  end

  test 'only one artist should be created if artist and album_artist are equal' do
    @runner.location.update(path: Rails.root.join('test/files/success-equal-artists'))

    @runner.send(:run)
    @runner.reload

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 1, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal %w[artist], Track.first.artists.map(&:name)
    assert_equal Track.first.artists.first, Album.first.artists.first
    assert_equal 'album', Album.first.title
    assert_equal 1, Album.first.artists.count
    assert_equal Date.new(1970, 1, 1), Album.first.release
    assert_equal 'genre', Genre.first.name
  end

  test 'artist should not be created if they already exist' do
    @runner.location.update(path: Rails.root.join('test/files/success-equal-artists'))
    Artist.create(name: 'artist')

    assert_difference('Artist.count', 0) do
      @runner.send(:run)
      @runner.reload
    end

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 1, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal %w[artist], Track.first.artists.map(&:name)
    assert_equal Track.first.artists.first, Album.first.artists.first
    assert_equal 'album', Album.first.title
    assert_equal 1, Album.first.artists.count
    assert_equal Date.new(1970, 1, 1), Album.first.release
    assert_equal 'genre', Genre.first.name
  end

  test 'album should not be created if it already exists' do
    @runner.location.update(path: Rails.root.join('test/files/success-equal-artists'))
    Album.create(title: 'album', release: Date.new(1970, 1, 1))

    assert_difference('Album.count', 0) do
      @runner.send(:run)
      @runner.reload
    end

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 1, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal %w[artist], Track.first.artists.map(&:name)
    assert_equal 'genre', Genre.first.name
  end

  test 'composer should not be created if they already exist' do
    @runner.location.update(path: Rails.root.join('test/files/success-one-file'))
    Artist.create(name: 'composer')

    assert_difference('Artist.count', 2) do
      @runner.send(:run)
      @runner.reload
    end

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 3, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal 'album', Album.first.title
    assert_equal 1, Album.first.artists.count
    assert_equal Date.new(1970, 1, 1), Album.first.release
    assert_equal 'genre', Genre.first.name
  end

  test 'genre should not be created if it already exists' do
    @runner.location.update(path: Rails.root.join('test/files/success-one-file'))
    # Also checks that normalized version is used for matching
    Genre.create(name: 'Genré')

    assert_difference('Genre.count', 0) do
      @runner.send(:run)
      @runner.reload
    end

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 3, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal 'album', Album.first.title
    assert_equal 1, Album.first.artists.count
    assert_equal Date.new(1970, 1, 1), Album.first.release
  end

  test 'should create album with cover if applicable' do
    @runner.location.update(path: Rails.root.join('test/files/success-with-cover'))

    assert_difference('Image.count', 1) do
      @runner.send(:run)
    end
    @runner.reload

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 3, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal %w[artist composer], Track.first.artists.map(&:name).sort
    assert_equal 'album', Album.first.title
    assert_equal 'albumartist', Album.first.artists.first.name
    assert_equal Date.new(1970, 1, 1), Album.first.release
    assert Album.first.image.present?
    assert_equal 'genre', Genre.first.name
  end

  test 'should remove non-existent audio file afterwards' do
    @runner.location.update(path: Rails.root.join('test/files/success-one-file'))
    af = AudioFile.create(bitrate: 1, filename: 'non-existent.flac', length: 1, codec: Codec.first, location: Location.first, sample_rate: 44_100, bit_depth: 16)

    @runner.send(:run)
    @runner.reload

    assert_nil AudioFile.find_by(id: af.id)

    assert_equal '', @runner.error_text
    assert_not @runner.warning_text.empty?
    assert_includes @runner.warning_text, 'non-existent.flac'
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 3, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal %w[artist composer], Track.first.artists.map(&:name).sort
    assert_equal 'album', Album.first.title
    assert_equal 'albumartist', Album.first.artists.first.name
    assert_equal Date.new(1970, 1, 1), Album.first.release
    assert_equal 'genre', Genre.first.name
  end

  test 'should get full date from id3v2 tag' do
    @runner.location.update(path: Rails.root.join('test/files/success-full-date'))

    @runner.send(:run)
    @runner.reload

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 1, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal 'artist', Track.first.artists.first.name
    assert_equal 'album', Album.first.title
    assert_equal Date.new(1970, 2, 3), Album.first.release
    assert_equal 'genre', Genre.first.name
  end

  test 'should be able to ignore time in id3v2 date tage' do
    @runner.location.update(path: Rails.root.join('test/files/success-ignore-time'))

    @runner.send(:run)
    @runner.reload

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 1, Artist.count
    assert_equal 1, Track.count
    assert_equal 1, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal 'artist', Track.first.artists.first.name
    assert_equal 'album', Album.first.title
    assert_equal Date.new(1970, 2, 3), Album.first.release
    assert_equal 'genre', Genre.first.name
  end

  test 'should not fail if date has incorrect format' do
    @runner.location.update(path: Rails.root.join('test/files/success-invalid-date'))

    @runner.send(:run)
    @runner.reload

    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 4, @runner.processed
    assert_not @runner.running

    assert_equal 1, Album.count
    assert_equal 1, Artist.count
    assert_equal 4, Track.count
    assert_equal 4, AudioFile.count
    assert_equal 1, Genre.count

    assert_equal 'title', Track.first.title
    assert_equal 'artist', Track.first.artists.first.name
    assert_equal 'album', Album.first.title
    assert_equal Date.new(0), Album.first.release
    assert_equal 'genre', Genre.first.name
  end
end
