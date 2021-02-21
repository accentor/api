# == Schema Information
#
# Table name: content_lengths
#
#  id                  :bigint           not null, primary key
#  ffmpeg_version      :string           not null
#  length              :integer          not null
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#

require 'test_helper'

class ContentLengthTest < ActiveSupport::TestCase
  def setup
    # ContentLengths are automatically created when we create an AudioFile and CodecConversion. Manually creating one would result in an error due to uniqueness contraints.
    io = StringIO.new File.read(Rails.root.join('test/files/base.flac'))
    AudioFile.any_instance.stubs(:convert).returns(io)
    @audio_file = create(:audio_file)
    @codec_conversion = create(:codec_conversion)
    @content_length = ContentLength.first
  end

  test 'should automatically provide ffmpeg version' do
    assert_equal Rails.application.config.FFMPEG_VERSION, @content_length.ffmpeg_version
  end

end
