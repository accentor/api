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

FactoryBot.define do
  factory :audio_file do
    location
    codec
    filename { Faker::File.unique.file_name }
    length { Random.rand(1_000_000) }
    bitrate { Random.rand(1000) }
    sample_rate { Random.rand(10_000) }
    bit_depth { Random.rand(10) }
  end
end
