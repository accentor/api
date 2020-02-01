# == Schema Information
#
# Table name: genres
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#
# Indexes
#
#  index_genres_on_name             (name) UNIQUE
#  index_genres_on_normalized_name  (normalized_name)
#

FactoryBot.define do
  factory :genre do
    name {Faker::Music.unique.genre}
  end
end
