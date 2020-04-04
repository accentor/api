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
class AuthTokenSerializer < ActiveModel::Serializer
  attributes :id, :device_id, :user_id, :user_agent
end
