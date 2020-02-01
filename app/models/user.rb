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

class User < ApplicationRecord
  enum permission: %i[user moderator admin]

  has_secure_password

  has_many :auth_tokens, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :permission, presence: true
  
  def moderator?
    admin? || permission == 'moderator'
  end

end
