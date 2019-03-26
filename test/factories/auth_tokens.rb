# == Schema Information
#
# Table name: auth_tokens
#
#  id            :bigint(8)        not null, primary key
#  user_id       :bigint(8)        not null
#  device_id     :string           not null
#  hashed_secret :string           not null
#  user_agent    :string           not null
#

FactoryBot.define do
  factory :auth_token do
    user
    user_agent { Faker::Lorem::words(3) }

    factory :moderator_auth_token do
      association :user, factory: :moderator
    end

    factory :admin_auth_token do
      association :user, factory: :admin
    end
  end
end
