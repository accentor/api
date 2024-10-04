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

  def convert(codec_conversion, out_file_name)
    parameters = codec_conversion.ffmpeg_params.split
    Open3.popen2(
      'ffmpeg',
      '-i', full_path,
      '-f', codec_conversion.resulting_codec.extension,
      *parameters,
      '-map_metadata', '-1',
      '-map', 'a',
      out_file_name,
      err: [Rails.configuration.ffmpeg_log_location, 'a']
    )
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
