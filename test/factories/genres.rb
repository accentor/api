FactoryBot.define do
  factory :genre do
    name {Faker::Music.unique.genre}
  end
end
