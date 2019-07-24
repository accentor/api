# == Schema Information
#
# Table name: content_lengths
#
#  id                  :bigint           not null, primary key
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#  length              :integer          not null
#

class ContentLength < ApplicationRecord
  belongs_to :audio_file
  belongs_to :codec_conversion

  validates :audio_file, presence: true, uniqueness: {scope: :codec_conversion}
  validates :codec_conversion, presence: true
  validates :length, presence: true
end
