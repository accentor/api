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
# Indexes
#
#  index_auth_tokens_on_device_id  (device_id) UNIQUE
#  index_auth_tokens_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :auth_token do
    user
    user_agent {Faker::Internet.user_agent}

    factory :moderator_auth_token do
      association :user, factory: :moderator
    end

    factory :admin_auth_token do
      association :user, factory: :admin
    end
  end
end
