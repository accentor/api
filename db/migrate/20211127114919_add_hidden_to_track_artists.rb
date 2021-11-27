class AddHiddenToTrackArtists < ActiveRecord::Migration[6.1]
  def change
    add_column :track_artists, :hidden, :boolean, default: false
  end
end
