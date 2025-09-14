# == Schema Information
#
# Table name: auth_tokens
#
#  id          :bigint           not null, primary key
#  application :string
#  user_agent  :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  device_id   :string           not null
#  user_id     :bigint           not null
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
    user_agent { Faker::Internet.user_agent }

    factory :moderator_auth_token do
      user factory: %i[moderator]
    end

    factory :admin_auth_token do
      user factory: %i[admin]
    end
  end
end
