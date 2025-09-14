# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  permission      :integer          default("user"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_name  (name) UNIQUE
#

class User < ApplicationRecord
  enum :permission, { user: 0, moderator: 1, admin: 2 }

  has_secure_password

  has_many :auth_tokens, dependent: :destroy
  has_many :plays, dependent: :destroy
  has_many :playlists, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :permission, presence: true

  def moderator?
    admin? || permission == 'moderator'
  end
end
