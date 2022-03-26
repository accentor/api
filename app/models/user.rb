# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  permission      :integer          default("user"), not null
#

class User < ApplicationRecord
  enum permission: { user: 0, moderator: 1, admin: 2 }

  has_secure_password

  has_many :auth_tokens, dependent: :destroy
  has_many :plays, dependent: :destroy
  has_many :play_counts, dependent: nil

  validates :name, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :permission, presence: true

  def moderator?
    admin? || permission == 'moderator'
  end
end
