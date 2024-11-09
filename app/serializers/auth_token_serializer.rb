# == Schema Information
#
# Table name: auth_tokens
#
#  id            :bigint           not null, primary key
#  application   :string
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
class AuthTokenSerializer < ActiveModel::Serializer
  attributes :id, :device_id, :user_id, :user_agent, :application
end
