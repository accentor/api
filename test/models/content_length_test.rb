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

  test 'should remain if ffmpeg version matches' do
    @content_length.check_ffmpeg_version
    @content_length.reload
    assert_not_nil @content_length.id
  end

  test 'should destroy if ffmpeg version does not match' do
    # rubocop:disable Rails/SkipsModelValidations
    # We want to avoid our own before_save callback to manually set a wrong version
    @content_length.update_column(:ffmpeg_version, Faker::App.semantic_version)
    # rubocop:enable Rails/SkipsModelValidations
    assert_not_equal Rails.application.config.FFMPEG_VERSION, @content_length.ffmpeg_version
    @content_length.check_ffmpeg_version

    assert_raises(ActiveRecord::RecordNotFound) do
      @content_length.reload
    end
  end
end
