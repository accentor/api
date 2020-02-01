# == Schema Information
#
# Table name: albums
#
#  id                  :bigint           not null, primary key
#  edition             :date
#  edition_description :string
#  normalized_title    :string           not null
#  release             :date
#  review_comment      :string
#  title               :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image_id            :bigint
#
# Indexes
#
#  index_albums_on_image_id          (image_id) UNIQUE
#  index_albums_on_normalized_title  (normalized_title)
#
# Foreign Keys
#
#  fk_rails_...  (image_id => images.id)
#

FactoryBot.define do
  factory :album do
    title {Faker::Music.album}
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
