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
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  codec_id    :bigint           not null
#  location_id :bigint           not null
#
# Indexes
#
#  index_audio_files_on_codec_id                  (codec_id)
#  index_audio_files_on_location_id               (location_id)
#  index_audio_files_on_location_id_and_filename  (location_id,filename) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (codec_id => codecs.id)
#  fk_rails_...  (location_id => locations.id)
#

require 'test_helper'

class AudioFileTest < ActiveSupport::TestCase
  class ProcessStub
    def initialize(exit_status)
      @exit_status = exit_status
    end

    def success? = @exit_status.zero?
    def to_i = @exit_status
  end

  def setup
    location = Location.create(path: Rails.root.join('test/files'))
    codec = Codec.create(extension: 'flac', mimetype: 'audio/flac')
    @audio_file = AudioFile.create(bitrate: 0, filename: 'base.flac', length: 100, codec:, location:, sample_rate: 0, bit_depth: 0)
  end

  test 'convert should not crash' do
    codec_conversion = create(:codec_conversion)

    path = TranscodedItem.path_for(codec_conversion, SecureRandom.uuid)

    Open3.stubs(:capture2).once.returns(['', ProcessStub.new(0)]).with do |*args, **kwargs|
      args.include?('ffmpeg') && args.include?(@audio_file.full_path) && args[-1] == path && kwargs.key?(:err)
    end

    @audio_file.convert(codec_conversion, path)
  end

  test 'convert should raise if underlying process fails' do
    codec_conversion = create(:codec_conversion)

    Open3.stubs(:capture2).once.returns(['', ProcessStub.new(9)])

    assert_raises AudioFile::FailedTranscode do
      @audio_file.convert(codec_conversion, TranscodedItem.path_for(codec_conversion, SecureRandom.uuid))
    end
  end

  test 'convert_with_tmpfile should clean up after itself' do
    codec_conversion = create(:codec_conversion)
    path = TranscodedItem.path_for(codec_conversion, SecureRandom.uuid)
    sent_filename = nil
    FileUtils.stubs(:mv).once.with { |tmp_path, out_file_name| out_file_name == path && tmp_path == sent_filename }
    with_stubbed_audio_file_convert ->(_codec_conversion, out_file_name) { sent_filename = out_file_name } do
      @audio_file.convert_with_tmpfile(codec_conversion, path)
    end

    assert_not_equal sent_filename, path
  end

  test 'convert_with_tmpfile should clean up after itself even when raising' do
    sent_filename = nil
    FileUtils.stubs(:rm_f).once.with { |tmp_path| tmp_path == sent_filename }
    with_stubbed_audio_file_convert lambda { |_codec_conversion, out_file_name|
      sent_filename = out_file_name
      raise AudioFile::FailedTranscode, 'oh no'
    } do
      codec_conversion = create(:codec_conversion)
      assert_raises AudioFile::FailedTranscode, 'oh no' do
        @audio_file.convert_with_tmpfile(codec_conversion, TranscodedItem.path_for(codec_conversion, SecureRandom.uuid))
      end
    end
  end

  test "should touch the associated track when it's destroyed" do
    one_day_ago = 1.day.ago
    track = Track.create(number: 0, title: 'title', album: Album.create(title: 'title'), audio_file: @audio_file, updated_at: one_day_ago)

    assert_equal one_day_ago, track.updated_at

    @audio_file.destroy

    assert_not_equal one_day_ago, track.reload.updated_at
  end
end
