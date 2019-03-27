FactoryBot.define do
  factory :codec_conversion do
    association :resulting_codec, factory: :codec
    name {Faker::Lorem.unique.word}
    ffmpeg_params {Faker::Lorem.words 10}
  end
end
