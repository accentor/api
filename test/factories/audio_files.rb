# == Schema Information
#
# Table name: audio_files
#
#  id          :bigint           not null, primary key
#  bitrate     :integer          not null
#  filename    :string           not null
#  length      :integer          not null
#  codec_id    :bigint           not null
#  location_id :bigint           not null
#

FactoryBot.define do
  factory :audio_file do
    location
    codec
    filename { Faker::File.unique.file_name }
    length { Random.rand(1_000_000) }
    bitrate { Random.rand(1000) }
  end
end
