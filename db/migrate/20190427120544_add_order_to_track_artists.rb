class AddOrderToTrackArtists < ActiveRecord::Migration[5.2]
  def change
    add_column :track_artists, :order, :integer
    Track.find_each do |t|
      t.track_artists.map.with_index {|ta, i| ta.update(order: i + 1)}
    end
    change_column_null :track_artists, :order, false
  end
end
