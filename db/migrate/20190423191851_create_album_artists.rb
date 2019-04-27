class CreateAlbumArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :album_artists do |t|
      t.references :album, foreign_key: true, null: false
      t.references :artist, foreign_key: true, null: false
      t.string :name, null: false
      t.integer :order, null: false
      t.string :separator

      t.index [:album_id, :artist_id, :name], unique: true
    end

    Album.find_each do |a|
      artist = Artist.find_by(name: a.albumartist) || Artist.new(name: a.albumartist, review_comment: 'New artist')
      AlbumArtist.create(album: a, artist: artist, name: artist.name, order: 0, separator: nil)
    end

    remove_column :albums, :albumartist
  end
end
