class CreateAuthTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :auth_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :device_id, null: false
      t.string :hashed_secret, null: false
      t.string :user_agent, null: false

      t.index :device_id, unique: true
    end
  end
end
