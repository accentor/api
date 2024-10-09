require 'test_helper'

class QueueTranscodedItemsForCodecConversionJobTest < ActiveJob::TestCase
  setup do
    @audio_file = create(:audio_file, location: create(:location), filename: '/base.flac', codec: create(:codec))
    create(:track, audio_file: @audio_file)
    @codec_conversion = create(:codec_conversion)
  end

  test 'should not enqueue job if audio is shorter than config and track is older than config' do
    # rubocop:disable Rails/SkipsModelValidations
    # We want to avoid our own before_save callbacks to manually set audio_file length and track age
    @audio_file.update_column(:length, 1)
    @audio_file.track.update_column(:created_at, 1.year.ago)
    # rubocop:enable Rails/SkipsModelValidations

    assert_no_enqueued_jobs do
      QueueTranscodedItemsForCodecConversionJob.perform_now(@codec_conversion)
    end
  end

  test 'should enqueue job if audio is longer than config' do
    # rubocop:disable Rails/SkipsModelValidations
    # We want to avoid our own before_save callbacks to manually set the audio_file length and track age
    @audio_file.update_column(:length, 1000)
    @audio_file.track.update_column(:created_at, 1.year.ago)
    # rubocop:enable Rails/SkipsModelValidations

    assert_enqueued_jobs 1 do
      QueueTranscodedItemsForCodecConversionJob.perform_now(@codec_conversion)
    end
  end

  test 'should enqueue job if track is newer than config' do
    # rubocop:disable Rails/SkipsModelValidations
    # We want to avoid our own before_save callbacks to manually set the audio_file length and track age
    @audio_file.update_column(:length, 1)
    @audio_file.track.update_column(:created_at, 1.day.ago)
    # rubocop:enable Rails/SkipsModelValidations

    assert_enqueued_jobs 1 do
      QueueTranscodedItemsForCodecConversionJob.perform_now(@codec_conversion)
    end
  end
end
