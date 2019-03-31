require 'open3'

# == Schema Information
#
# Table name: audio_files
#
#  id          :bigint(8)        not null, primary key
#  location_id :bigint(8)        not null
#  codec_id    :bigint(8)        not null
#  filename    :string           not null
#  length      :integer          not null
#  bitrate     :integer          not null
#

class AudioFile < ApplicationRecord
  belongs_to :location
  belongs_to :codec
  has_one :track, dependent: :nullify

  validates :location, presence: true
  validates :codec, presence: true
  validates :filename, presence: true, uniqueness: {scope: :location}
  validates :length, presence: true
  validates :bitrate, presence: true

  def check_self
    if File.exist?(File.join(location.path, filename))
      return true
    end
    destroy
    false
  end

  def convert(codec_conversion = nil)
    unless codec_conversion
      return File.open(File.join(location.path, filename))
    end
    parameters = codec_conversion.ffmpeg_params.split
    stdin, stdout, _ = Open3.popen2(
        'ffmpeg',
        '-i', File.join(location.path, filename),
        '-f', codec_conversion.resulting_codec.extension,
        *parameters,
        '-map_metadata', '-1',
        '-map', 'a', '-',
        err: [Rails.root.join('log', 'ffmpeg.log').to_s, 'a']
    )
    stdin.close
    stdout
  end
end
