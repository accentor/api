class CreatePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :playlists do |t|
      t.string :name, null: false
      t.string :description
      t.integer :playlist_type, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :access, default: 0

      t.timestamps
    end
  end
end
