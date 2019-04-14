class CreateTrackGenreJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :tracks, :genres, column_options: {foreign_key: true} do |t|
      t.index :genre_id
      t.index :track_id
      t.index [:track_id, :genre_id], unique: true
    end
  end
end
