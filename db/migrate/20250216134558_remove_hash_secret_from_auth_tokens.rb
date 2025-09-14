class RemoveHashSecretFromAuthTokens < ActiveRecord::Migration[8.0]
  def up
    remove_column :auth_tokens, :hashed_secret, :string, null: false
  end

  def down
    add_column :auth_tokens, :hashed_secret, :string, null: true

    AuthToken.find_each do |at|
      at.secret = SecureRandom.urlsafe_base64(48)
      at.hashed_secret = BCrypt::Password.create(secret, cost: 10)
      at.save!
    end

    change_column_null :auth_tokens, :hashed_secret, false
  end
end
