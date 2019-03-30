# == Schema Information
#
# Table name: genres
#
#  id   :bigint(8)        not null, primary key
#  name :string           not null
#

FactoryBot.define do
  factory :genre do
    name {Faker::Music.unique.genre}
  end
end
