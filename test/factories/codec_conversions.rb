# == Schema Information
#
# Table name: codec_conversions
#
#  id                 :bigint           not null, primary key
#  name               :string           not null
#  ffmpeg_params      :string           not null
#  resulting_codec_id :bigint           not null
#

FactoryBot.define do
  factory :codec_conversion do
    association :resulting_codec, factory: :codec
    name {Faker::Lorem.unique.word}
    ffmpeg_params {Faker::Lorem.words 10}
  end
end
