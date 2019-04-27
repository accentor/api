# == Schema Information
#
# Table name: album_artists
#
#  id        :bigint(8)        not null, primary key
#  album_id  :bigint(8)        not null
#  artist_id :bigint(8)        not null
#  name      :string           not null
#  order     :integer          not null
#  join      :string
#

class AlbumArtist < ApplicationRecord
  belongs_to :album
  belongs_to :artist

  validates :name, presence: true
  validates :order, presence: true
end
