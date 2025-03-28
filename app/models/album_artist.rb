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
# Indexes
#
#  index_album_artists_on_album_id                         (album_id)
#  index_album_artists_on_album_id_and_artist_id_and_name  (album_id,artist_id,name) UNIQUE
#  index_album_artists_on_artist_id                        (artist_id)
#  index_album_artists_on_normalized_name                  (normalized_name)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#  fk_rails_...  (artist_id => artists.id)
#

class AlbumArtist < ApplicationRecord
  include HasNormalized

  belongs_to :album
  belongs_to :artist

  validates :name, presence: true
  validates :order, presence: true

  normalized_col_generator :name
end
