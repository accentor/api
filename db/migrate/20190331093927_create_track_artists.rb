class CreateTrackArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :track_artists do |t|
      t.references :track, foreign_key: true, null: false
      t.references :artist, foreign_key: true, null: false
      t.string :name, null: false
      t.integer :role, null: false

      t.index [:track_id, :artist_id, :name, :role], unique: true
    end
  end
end
