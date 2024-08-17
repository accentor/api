class AddApplicationToAuthTokens < ActiveRecord::Migration[7.2]
  def change
    add_column :auth_tokens, :application, :string
  end
end
