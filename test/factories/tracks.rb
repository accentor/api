# == Schema Information
#
# Table name: tracks
#
#  id             :bigint(8)        not null, primary key
#  title          :string           not null
#  number         :integer          not null
#  audio_file_id  :bigint(8)
#  album_id       :bigint(8)        not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  review_comment :string
#

FactoryBot.define do
  factory :track do
    album
    title {Faker::Lorem.word}
    number {Random.rand(20)}
    review_comment {Faker::Lorem.word}
    trait :with_audio_file do
      association :audio_file, factory: :audio_file
    end
  end
end
