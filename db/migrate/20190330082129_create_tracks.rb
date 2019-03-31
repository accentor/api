class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.string :title, null: false
      t.integer :number, null: false
      t.references :audio_file, foreign_key: true, index: {unique: true}
      t.references :album, foreign_key: true, null: false

      t.timestamps
    end
  end
end
