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
    Location.create(path: Rails.root.join('test/files'))
    Codec.create(extension: 'flac', mimetype: 'audio/flac')
  end

  test 'check_file should add sample_rate and bit_depth' do
    af = AudioFile.create(bitrate: 0, filename: 'base.flac', length: 100, codec: Codec.first, location: Location.first, sample_rate: 0, bit_depth: 0)
    af.check_file_attributes
    af.reload

    assert_equal 48_000, af.sample_rate
    assert_equal 16, af.bit_depth
    assert_equal 768, af.bitrate
    assert_equal 0, af.length
  end
end
