# == Schema Information
#
# Table name: audio_files
#
#  id          :bigint           not null, primary key
#  bit_depth   :integer          not null
#  bitrate     :integer          not null
#  filename    :string           not null
#  length      :integer          not null
#  sample_rate :integer          not null
#  codec_id    :bigint           not null
#  location_id :bigint           not null
#

require 'test_helper'

class AudioFileTest < ActiveSupport::TestCase
  def setup
    location = Location.create(path: Rails.root.join('test/files'))
    codec = Codec.create(extension: 'flac', mimetype: 'audio/flac')
    @audio_file = AudioFile.create(bitrate: 0, filename: 'base.flac', length: 100, codec:, location:, sample_rate: 0, bit_depth: 0)
  end

  test 'convert should not crash' do
    codec_conversion = create(:codec_conversion)

    path = TranscodedItem.path_for(codec_conversion, SecureRandom.uuid)

    Open3.stubs(:popen2).once.with do |*args, **kwargs|
      args.include?('ffmpeg') && args.include?(@audio_file.full_path) && args[-1] == path && kwargs.key?(:err)
    end

    @audio_file.convert(codec_conversion, path)
  end
end
