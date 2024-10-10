require 'open3'

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

class AudioFile < ApplicationRecord
  class FailedTranscode < StandardError; end

  belongs_to :location
  belongs_to :codec
  has_one :track, dependent: :nullify
  has_many :transcoded_items, dependent: :destroy

  validates :filename, presence: true, uniqueness: { scope: :location }
  validates :length, presence: true
  validates :bitrate, presence: true
  validates :sample_rate, presence: true
  validates :bit_depth, presence: true

  after_create :queue_create_transcoded_items

  def check_self
    return true if File.exist?(full_path)

    destroy
    false
  end

  def convert_with_tmpfile(codec_conversion, out_file_name)
    tmp_path = File.join(Dir.tmpdir, "accentor_transcode-#{id}-#{codec_conversion.id}-#{SecureRandom.uuid}")
    convert(codec_conversion, tmp_path)
    FileUtils.mv tmp_path, out_file_name
  ensure
    FileUtils.rm_f tmp_path
  end

  def convert(codec_conversion, out_file_name)
    parameters = codec_conversion.ffmpeg_params.split
    _stdout, status = Open3.capture2(
      'ffmpeg',
      '-i', full_path,
      '-f', codec_conversion.resulting_codec.extension,
      *parameters,
      '-map_metadata', '-1',
      '-map', 'a',
      out_file_name,
      err: [Rails.configuration.ffmpeg_log_location, 'a']
    )
    raise FailedTranscode, "ffmpeg exited with #{status.to_i}" unless status.success?
  end

  def full_path
    File.join(location.path, filename)
  end

  def queue_create_transcoded_items
    CodecConversion.find_each do |cc|
      CreateTranscodedItemJob.perform_later(self, cc)
    end
  end
end
