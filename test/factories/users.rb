# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  permission      :integer          default("user"), not null
#

FactoryBot.define do
  factory :user do
    name { Faker::Internet.unique.username }
    password { Faker::Internet.password }
    permission { :user }

    factory :moderator do
      permission { :moderator }
    end

    factory :admin do
      permission { :admin }
    end
  end
end
