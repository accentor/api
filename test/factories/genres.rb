# == Schema Information
#
# Table name: genres
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#

FactoryBot.define do
  factory :genre do
    name { Faker::Music.unique.genre }
  end
end
