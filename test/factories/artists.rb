# == Schema Information
#
# Table name: artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#  review_comment  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  image_id        :bigint
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
