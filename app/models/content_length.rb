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

class ContentLength < ApplicationRecord
  belongs_to :audio_file
  belongs_to :codec_conversion

  validates :audio_file, presence: true, uniqueness: { scope: :codec_conversion }
  validates :codec_conversion, presence: true
  validates :length, presence: true

  before_save :set_ffmpeg_version

  def check_ffmpeg_version
    return true if ffmpeg_version == Rails.application.config.FFMPEG_VERSION

    destroy

    if audio_file.length > Rails.application.config.recalculate_content_length_if_longer_than ||
       audio_file.track.created_at.after?(Rails.application.config.recalculate_content_length_if_newer_than.call)
      CodecConversion.find_each do |cc|
        audio_file.delay(queue: :content_lengths_backlog).calc_audio_length(cc)
      end
    end

    false
  end

  private

  def set_ffmpeg_version
    self.ffmpeg_version = Rails.application.config.FFMPEG_VERSION
  end
end
