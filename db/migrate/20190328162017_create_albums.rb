class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.string :title, null: false
      t.string :albumartist, null: false
      t.references :image, foreign_key: true
      t.date :release

      t.timestamps

      t.index :image_id, unique: true, name: 'index_albums_on_image_id_unique'
    end
  end
end
