class AlbumArtistSerializer < ActiveModel::Serializer
  attributes :artist_id, :name, :normalized_name, :order, :separator
end
