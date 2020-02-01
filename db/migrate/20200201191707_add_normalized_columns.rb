class AddNormalizedColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :album_artists, :normalized_name, :string
    add_column :albums, :normalized_title, :string
    add_column :artists, :normalized_name, :string
    add_column :genres, :normalized_name, :string
    add_column :labels, :normalized_name, :string
    add_column :track_artists, :normalized_name, :string
    add_column :tracks, :normalized_title, :string
    AlbumArtist.find_each do |aa|
      aa.generate_normalized_name
      aa.save!
    end
    Album.find_each do |a|
      a.generate_normalized_title
      a.save!
    end
    Artist.find_each do |a|
      a.generate_normalized_name
      a.save!
    end
    Genre.find_each do |g|
      g.generate_normalized_name
      g.save!
    end
    Label.find_each do |l|
      l.generate_normalized_name
      l.save!
    end
    TrackArtist.find_each do |ta|
      ta.generate_normalized_name
      ta.save!
    end
    Track.find_each do |t|
      t.generate_normalized_title
      t.save!
    end
    change_column_null :album_artists, :normalized_name, false
    change_column_null :albums, :normalized_title, false
    change_column_null :artists, :normalized_name, false
    change_column_null :genres, :normalized_name, false
    change_column_null :labels, :normalized_name, false
    change_column_null :track_artists, :normalized_name, false
    change_column_null :tracks, :normalized_title, false
    add_index :album_artists, :normalized_name
    add_index :albums, :normalized_title
    add_index :artists, :normalized_name
    add_index :genres, :normalized_name
    add_index :labels, :normalized_name
    add_index :track_artists, :normalized_name
    add_index :tracks, :normalized_title
  end
end
