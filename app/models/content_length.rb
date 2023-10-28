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
end
