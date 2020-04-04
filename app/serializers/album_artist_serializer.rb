# == Schema Information
#
# Table name: album_artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#  order           :integer          not null
#  separator       :string
#  album_id        :bigint           not null
#  artist_id       :bigint           not null
#
class AlbumArtistSerializer < ActiveModel::Serializer
  attributes :artist_id, :name, :normalized_name, :order, :separator
end
