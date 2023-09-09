# == Schema Information
#
# Table name: content_lengths
#
#  id                  :bigint           not null, primary key
#  length              :integer          not null
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#

class ContentLength < ApplicationRecord
  belongs_to :audio_file
  belongs_to :codec_conversion

  validates :audio_file, uniqueness: { scope: :codec_conversion }
  validates :length, presence: true

  def self.destroy_all_and_recalculate
    destroy_all

    AudioFile.find_each do |af|
      next unless Rails.application.config.recalculate_content_length_if.call af

      CodecConversion.find_each do |cc|
        CalculateContentLengthJob.set(queue: :whenever).perform_later(af, cc)
      end
    end
  end
end
