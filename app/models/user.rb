# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  permission      :integer          default("user"), not null
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
