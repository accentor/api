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
    stdin = StringIO.new
    stdout = StringIO.new Rails.root.join('test/files/base.flac').read
    Open3.stubs(:popen2).returns([stdin, stdout, 0])
    ret_out = @audio_file.convert(create(:codec_conversion))

    assert_predicate stdin, :closed?
    assert_equal stdout, ret_out
  end

  test 'convert should not write to stdin' do
    stdin = StringIO.new
    stdout = StringIO.new Rails.root.join('test/files/base.flac').read
    Open3.stubs(:popen2).returns([stdin, stdout, 0])
    ret_out = @audio_file.convert(create(:codec_conversion))

    assert_predicate stdin, :closed?
    assert_equal '', stdin.string
    assert_equal stdout, ret_out
  end
end
