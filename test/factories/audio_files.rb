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

FactoryBot.define do
  factory :audio_file do
    location
    codec
    filename { Faker::File.unique.file_name }
    length { Random.rand(1_000_000) }
    bitrate { Random.rand(1000) }
  end
end
