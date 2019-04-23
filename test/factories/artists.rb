# == Schema Information
#
# Table name: artists
#
#  id             :bigint(8)        not null, primary key
#  name           :string           not null
#  image_id       :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  review_comment :string
#

FactoryBot.define do
  factory :artist do
    name {Faker::Artist.name}
    review_comment {Faker::Lorem.word}

    trait :with_image do
      association :image, factory: :image
    end
  end
end
