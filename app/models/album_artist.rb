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

class AlbumArtist < ApplicationRecord
  include HasNormalized

  belongs_to :album
  belongs_to :artist

  validates :name, presence: true
  validates :order, presence: true

  normalized_col_generator :name
end
