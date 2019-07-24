# == Schema Information
#
# Table name: content_lengths
#
#  id                  :bigint           not null, primary key
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#  length              :integer          not null
#

FactoryBot.define do
  factory :content_length do
    audio_file
    codec_conversion
    length {1000}
  end
end
