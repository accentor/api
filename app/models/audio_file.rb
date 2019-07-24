require 'open3'

# == Schema Information
#
# Table name: audio_files
#
#  id          :bigint           not null, primary key
#  location_id :bigint           not null
#  codec_id    :bigint           not null
#  filename    :string           not null
#  length      :integer          not null
#  bitrate     :integer          not null
#

class AudioFile < ApplicationRecord
  belongs_to :location
  belongs_to :codec
  has_one :track, dependent: :nullify
  has_many :content_lengths, dependent: :destroy

  validates :location, presence: true
  validates :codec, presence: true
  validates :filename, presence: true, uniqueness: {scope: :location}
  validates :length, presence: true
  validates :bitrate, presence: true

  after_save :queue_content_length_calculations

  def check_self
    if File.exist?(File.join(location.path, filename))
      return true
    end
    destroy
    false
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
        err: [Rails.root.join('log', 'ffmpeg.log').to_s, 'a']
    )
    stdin.close
    stdout
  end

  def calc_audio_length(codec_conversion)
    parameters = codec_conversion.ffmpeg_params.split
    stdin, stdout, = Open3.popen2(
        'ffmpeg',
        '-i', full_path,
        '-f', codec_conversion.resulting_codec.extension,
        *parameters,
        '-map_metadata', '-1',
        '-map', 'a', '-',
        err: [Rails.root.join('log', 'ffmpeg.log').to_s, 'a']
    )
    stdin.close
    length = 0
    while (bytes = stdout.read(16.kilobytes))
      length += bytes.length
    end
    ContentLength.create(audio_file: self, codec_conversion: codec_conversion, length: length)
  end

  def full_path
    File.join(location.path, filename)
  end

  def queue_content_length_calculations
    ContentLength.where(audio_file: self).destroy_all
    CodecConversion.find_each do |cc|
      delay(priority: 10).calc_audio_length(cc)
    end
  end
end
