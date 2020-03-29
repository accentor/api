class AuthTokenSerializer < ActiveModel::Serializer
  attributes :id, :device_id, :user_id, :user_agent
end
