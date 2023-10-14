# == Schema Information
#
# Table name: auth_tokens
#
#  id            :bigint           not null, primary key
#  hashed_secret :string           not null
#  user_agent    :string           not null
#  device_id     :string           not null
#  user_id       :bigint           not null
#

FactoryBot.define do
  factory :auth_token do
    user
    user_agent { Faker::Internet.user_agent }

    factory :moderator_auth_token do
      user factory: %i[moderator]
    end

    factory :admin_auth_token do
      user factory: %i[admin]
    end
  end
end
