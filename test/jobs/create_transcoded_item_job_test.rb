require 'test_helper'

class CreateTranscodedItemJobTest < ActiveJob::TestCase
  setup do
    location = Location.create(path: Rails.root.join('test/files'))
    flac = Codec.create(mimetype: 'audio/flac', extension: 'flac')
    @audio_file = create(:audio_file, location:, filename: '/base.flac', codec: flac)
    @codec_conversion = create(:codec_conversion)

    AudioFile.alias_method :old_convert, :convert
    AudioFile.define_method :convert, ->(_codec_conversion, out_file_name) { FileUtils.cp full_path, out_file_name }
  end

  teardown do
    AudioFile.alias_method :convert, :old_convert
  end

  test 'should create a new TranscodedItem with existing file' do
    assert_difference('TranscodedItem.count', 1) do
      CreateTranscodedItemJob.perform_now(@audio_file, @codec_conversion)
    end
    assert_path_exists TranscodedItem.find_by(audio_file: @audio_file, codec_conversion: @codec_conversion).path
  end

  test 'should abort when TranscodedItem was created while job was waiting' do
    CreateTranscodedItemJob.perform_later(@audio_file, @codec_conversion)

    AudioFile.stubs(:convert).never
    TranscodedItem.create!(audio_file: @audio_file, codec_conversion: @codec_conversion, uuid: '0000-0000-0000')

    perform_enqueued_jobs
  end

  test 'should abort when TranscodedItem was created while converting' do
    audio_file = @audio_file
    codec_conversion = @codec_conversion
    AudioFile.define_method :convert, lambda { |_codec_conversion, _out_file_name|
      TranscodedItem.create!(audio_file:, codec_conversion:, uuid: '0000-0000-0000')
    }

    FileUtils.stubs(:rm_f).once

    CreateTranscodedItemJob.perform_now(@audio_file, @codec_conversion)
  end
end
