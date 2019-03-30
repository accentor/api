class CreateAlbumLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :album_labels do |t|
      t.references :album, foreign_key: true, null: false
      t.references :label, foreign_key: true, null: false
      t.string :catalogue_number, null: false

      t.index [:album_id, :label_id], unique: true
    end
  end
end
