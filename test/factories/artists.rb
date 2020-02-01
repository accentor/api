# == Schema Information
#
# Table name: artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  image_id        :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  review_comment  :string
#  normalized_name :string           not null
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
