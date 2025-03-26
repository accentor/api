# == Schema Information
#
# Table name: auth_tokens
#
#  id          :bigint           not null, primary key
#  application :string
#  user_agent  :string           not null
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

class AuthToken < ApplicationRecord
  belongs_to :user

  validates :device_id, presence: true, uniqueness: true
  validates :user_agent, presence: true
  before_validation :generate_device_id, unless: :device_id?

  generates_token_for :api, &:device_id

  private

  def generate_device_id
    loop do
      self.device_id = SecureRandom.hex(12)
      break unless AuthToken.exists?(device_id:)
    end
  end
end
