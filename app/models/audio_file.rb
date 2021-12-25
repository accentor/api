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
  belongs_to :location
  belongs_to :codec
  has_one :track, dependent: :nullify
  has_many :content_lengths, dependent: :destroy
  has_many :transcoded_items, dependent: :destroy

  validates :filename, presence: true, uniqueness: { scope: :location }
  validates :length, presence: true
  validates :bitrate, presence: true
  validates :sample_rate, presence: true
  validates :bit_depth, presence: true

  after_save :queue_content_length_calculations

  def check_self
    return true if File.exist?(full_path)

    destroy
    false
  end

  def check_file_attributes
    return unless check_self

    tag = WahWah.open(full_path)
    update(length: tag.duration, bitrate: tag.bitrate || 0, sample_rate: tag.sample_rate || 0, bit_depth: tag.bit_depth || 0)
  end

  def convert(codec_conversion)
    parameters = codec_conversion.ffmpeg_params.split
    stdin, stdout, = Open3.popen2(
      'ffmpeg',
      '-i', full_path,
      '-f', codec_conversion.resulting_codec.extension,
      *parameters,
      '-map_metadata', '-1',
      '-map', 'a', '-',
      err: [Rails.configuration.ffmpeg_log_location, 'a']
    )
    stdin.close
    stdout
  end

  def calc_audio_length(codec_conversion)
    existing = ContentLength.find_by(audio_file: self, codec_conversion: codec_conversion)
    return existing if existing.present?

    stdout = convert(codec_conversion)
    length = 0
    while (bytes = stdout.read(16.kilobytes))
      length += bytes.length
    end

    ContentLength.find_or_create_by(audio_file: self, codec_conversion: codec_conversion) do |cl|
      cl.length = length
    end
  end

  def full_path
    File.join(location.path, filename)
  end

  def queue_content_length_calculations
    ContentLength.where(audio_file: self).destroy_all
    CodecConversion.find_each do |cc|
      delay(queue: :content_lengths).calc_audio_length(cc)
    end
  end
end
