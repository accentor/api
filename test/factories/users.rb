# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  permission      :integer          default("user"), not null
#

FactoryBot.define do
  factory :user do
    name {Faker::Name.unique.name}
    password {Faker::Lorem.characters(20)}
    permission {:user}

    factory :moderator do
      permission {:moderator}
    end

    factory :admin do
      permission {:admin}
    end
  end
end
