# == Schema Information
#
# Table name: albums
#
#  id          :bigint(8)        not null, primary key
#  title       :string           not null
#  albumartist :string           not null
#  image_id    :bigint(8)
#  release     :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :album do
    title {Faker::Music.album}
    albumartist {Faker::Music.band}
    review_comment {Faker::Lorem.word}

    trait :with_release do
      release {Faker::Date.backward(365 * 100)}
    end

    trait :with_image do
      association :image, factory: :image
    end

    transient do
      label_count {5}
    end

    after(:build) do |album, evaluator|
      build_list(:album_label, evaluator.label_count, album: album)
    end
  end
end
