# == Schema Information
#
# Table name: labels
#
#  id   :bigint(8)        not null, primary key
#  name :string           not null
#

FactoryBot.define do
  factory :label do
    name {Faker::Lorem.word}
  end
end
