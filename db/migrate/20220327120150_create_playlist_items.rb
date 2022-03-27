class CreatePlaylistItems < ActiveRecord::Migration[7.0]
  def change
    create_table :playlist_items do |t|
      t.references :playlist, null: false, foreign_key: true
      t.integer :item_id, null: false
      t.string :item_type, null: false
      t.integer :order, null: false

      t.timestamps
    end
  end
end
