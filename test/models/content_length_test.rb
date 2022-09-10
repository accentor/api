# == Schema Information
#
# Table name: content_lengths
#
#  id                  :bigint           not null, primary key
#  length              :integer          not null
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#

require 'test_helper'

class ContentLengthTest < ActiveSupport::TestCase
  def setup
    # ContentLengths are automatically created when we create an AudioFile and CodecConversion. Manually creating one would result in an error due to uniqueness contraints.
    io = StringIO.new Rails.root.join('test/files/base.flac').read
    AudioFile.any_instance.stubs(:convert).returns(io)
    @audio_file = create(:audio_file)
    @codec_conversion = create(:codec_conversion)
  end

  test 'should not create new ContentLength if audio is longer than config and track is older than config' do
    @track = create(:track, audio_file: @audio_file)

    # rubocop:disable Rails/SkipsModelValidations
    # We want to avoid our own before_save callbacks to manually set audio_file length and track age
    @audio_file.update_column(:length, 1)
    @audio_file.track.update_column(:created_at, 1.year.ago)
    # rubocop:enable Rails/SkipsModelValidations

    assert_difference('ContentLength.count', -1) do
      ContentLength.destroy_all_and_recalculate
    end
  end

  test 'should create new ContentLength if audio is longer than config' do
    io = StringIO.new Rails.root.join('test/files/base.flac').read
    AudioFile.any_instance.stubs(:convert).returns(io)
    @track = create(:track, audio_file: @audio_file)

    # rubocop:disable Rails/SkipsModelValidations
    # We want to avoid our own before_save callbacks to manually set the audio_file length and track age
    @audio_file.update_column(:length, 1000)
    @audio_file.track.update_column(:created_at, 1.year.ago)
    # rubocop:enable Rails/SkipsModelValidations

    assert_difference('ContentLength.count', 0) do
      ContentLength.destroy_all_and_recalculate
    end
  end

  test 'should create new ContentLength if track is newer than config' do
    io = StringIO.new Rails.root.join('test/files/base.flac').read
    AudioFile.any_instance.stubs(:convert).returns(io)
    @track = create(:track, audio_file: @audio_file)

    # rubocop:disable Rails/SkipsModelValidations
    # We want to avoid our own before_save callbacks to manually set the audio_file length and track age
    @audio_file.update_column(:length, 1)
    @audio_file.track.update_column(:created_at, 1.day.ago)
    # rubocop:enable Rails/SkipsModelValidations

    assert_difference('ContentLength.count', 0) do
      ContentLength.destroy_all_and_recalculate
    end

    @audio_file.reload
    assert_equal 1, @audio_file.content_lengths.length
  end
end
