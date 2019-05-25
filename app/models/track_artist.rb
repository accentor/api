# == Schema Information
#
# Table name: track_artists
#
#  id        :bigint(8)        not null, primary key
#  track_id  :bigint(8)        not null
#  artist_id :bigint(8)        not null
#  name      :string           not null
#  role      :integer          not null
#

class TrackArtist < ApplicationRecord
  enum role: %i[main performer composer conductor remixer producer arranger]

  belongs_to :track
  belongs_to :artist

  validates :role, presence: true
  validates :name, presence: true, uniqueness: {scope: %i[track artist role]}
  validates :track, presence: true
  validates :artist, presence: true
  validates :order, presence: true
end
