class TrackArtistSerializer < ActiveModel::Serializer
  attributes :artist_id, :name, :normalized_name, :role, :order
end
