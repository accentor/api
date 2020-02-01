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
# Indexes
#
#  index_artists_on_image_id         (image_id) UNIQUE
#  index_artists_on_normalized_name  (normalized_name)
#
# Foreign Keys
#
#  fk_rails_...  (image_id => images.id)
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
