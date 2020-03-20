# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  permission      :integer          default("0"), not null
#

class User < ApplicationRecord
  enum permission: { user: 0, moderator: 1, admin: 2 }

  has_secure_password

  has_many :auth_tokens, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :permission, presence: true

  def moderator?
    admin? || permission == 'moderator'
  end
end
