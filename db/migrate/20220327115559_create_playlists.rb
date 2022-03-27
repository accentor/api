class CreatePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :playlists do |t|
      t.string :name, null: false
      t.string :description
      t.references :user, null: true, foreign_key: true
      t.integer :playlist_type, null: false

      t.timestamps
    end
  end
end
