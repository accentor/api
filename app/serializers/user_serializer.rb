# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  permission      :integer          default("user"), not null
#
# Indexes
#
#  index_users_on_name  (name) UNIQUE
#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :permission
end
