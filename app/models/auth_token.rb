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

class AuthToken < ApplicationRecord
  belongs_to :user

  validates :device_id, presence: true, uniqueness: true
  validates :hashed_secret, presence: true
  validates :user_agent, presence: true
  before_validation :generate_device_id, unless: :device_id?
  before_validation :generate_secret, unless: :hashed_secret?

  attr_accessor :secret

  generates_token_for :api, &:device_id

  def self.find_authenticated(credentials)
    token = find_by(device_id: credentials[:device_id])
    token if token&.secret_correct?(credentials[:secret])
  end

  def secret_correct?(secret)
    BCrypt::Password.new(hashed_secret) == secret
  end

  private

  def generate_device_id
    loop do
      self.device_id = SecureRandom.hex(12)
      break unless AuthToken.exists?(device_id:)
    end
  end

  def generate_secret
    self.secret = SecureRandom.urlsafe_base64(48)
    self.hashed_secret = BCrypt::Password.create(secret, cost: Rails.configuration.token_hash_rounds)
  end
end
