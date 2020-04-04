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
require 'test_helper'

class RescanRunnerTest < ActiveSupport::TestCase
  setup do
    @runner = RescanRunner.create
    Codec.create(extension: 'flac', mimetype: 'audio/flac')
    Codec.create(extension: 'mp3', mimetype: 'audio/mpeg')
    ImageType.create(extension: 'png', mimetype: 'image/png')
    ImageType.create(extension: 'jpg', mimetype: 'image/png')
    CoverFilename.create(filename: 'image')
  end

  test 'should complain when there are no locations' do
    @runner.run
    @runner.reload

    assert_not @runner.error_text.empty?
    assert_equal 0, @runner.processed
    assert_equal false, @runner.running
  end

  test 'should complain when there are no codecs' do
    Location.create(path: Rails.root.join('test/files/success-one-file'))
    Codec.destroy_all

    @runner.run
    @runner.reload

    assert_not @runner.error_text.empty?
    assert_equal 0, @runner.processed
    assert_equal false, @runner.running
  end

  test "should complain when location doesn't exist" do
    Location.create(path: Rails.root.join('test/files/doesnt-exist'))

    @runner.run
    @runner.reload

    assert_not @runner.error_text.empty?
    assert_equal 0, @runner.processed
    assert_equal false, @runner.running
  end

  test 'should complain when location is a file' do
    Location.create(path: Rails.root.join('test/files/base.flac'))

    @runner.run
    @runner.reload

    assert_not @runner.error_text.empty?
    assert_equal 0, @runner.processed
    assert_equal false, @runner.running
  end

  test 'should be able to read a file successfully' do
    Location.create(path: Rails.root.join('test/files/success-one-file'))

    @runner.run
    @runner.reload
    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_equal false, @runner.running

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

  test 'should be able to read a file from a nested directory successfully' do
    Location.create(path: Rails.root.join('test/files/success-nested'))

    @runner.run
    @runner.reload
    assert_equal '', @runner.error_text
    assert_equal '', @runner.warning_text
    assert_equal 1, @runner.processed
    assert_equal false, @runner.running

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

  test 'should be able to recover from catastrophic error' do
    Location.stubs(:all).raises('Catastrophic error')

    @runner.run
    @runner.reload
    assert_not @runner.error_text.empty?
    assert @runner.error_text.include?('Catastrophic error')
    assert_equal 0, @runner.processed
    assert_equal false, @runner.running
  end

  test 'should be able to recover from bad files and proceed' do
    Location.create(path: Rails.root.join('test/files/failure-bad-file'))
    # Make sure bad file is processed before good file
    Dir.stubs(:each_child).multiple_yields('empty.flac', 'all-tags.mp3')

    @runner.run
    @runner.reload

    assert_not @runner.error_text.empty?
    assert @runner.error_text.include?('empty.flac')
    assert_equal 1, @runner.processed
    assert_equal false, @runner.running
  end

  test 'should not do anything if runner is already running' do
    Location.create(path: Rails.root.join('test/files/success-one-file'))

    @runner.update(running: true, warning_text: 'unchanged', error_text: 'unchanged', processed: 64)
    @runner.run
    @runner.reload
    assert_equal 'unchanged', @runner.error_text
    assert_equal 'unchanged', @runner.warning_text
    assert_equal 64, @runner.processed
    assert_equal true, @runner.running
  end
end
