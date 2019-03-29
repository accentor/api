class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.string :title, null: false
      t.string :albumartist, null: false
      t.references :image, foreign_key: true, index: {unique: true}
      t.date :release

      t.timestamps
    end
  end
end
