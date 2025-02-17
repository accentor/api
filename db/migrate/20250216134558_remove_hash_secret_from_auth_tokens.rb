class RemoveHashSecretFromAuthTokens < ActiveRecord::Migration[8.0]
  def change
    remove_column :auth_tokens, :hashed_secret, :string, null: false

    # When running this migration in either direction all existing sessions are no longer valid.
    # Either they are still using device_id/secret in which case they can no longer be authenticated,
    # or they don't contain a hashed_secret, in which case our null-constraint would fail.
    AuthToken.in_batches(&:destroy_all)
  end
end
