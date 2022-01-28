class AddPlayTokenToAuthToken < ActiveRecord::Migration[6.1]

  def up
    change_table :auth_tokens do |t|
      t.string :play_token, null: true
      t.index :play_token
    end
    AuthToken.find_each do |token|
      token.validate # will trigger generate_play_token
      token.save
    end
    change_column :auth_tokens, :play_token, :string, null: false
  end

  def down
    remove_index :auth_tokens, :play_token
    remove_column :auth_tokens, :play_token
  end
end
