# == Schema Information
#
# Table name: track_artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#  order           :integer          not null
#  role            :integer          not null
#  artist_id       :bigint           not null
#  track_id        :bigint           not null
#

class TrackArtist < ApplicationRecord
  include HasNormalized

  enum role: %i[main performer composer conductor remixer producer arranger]

  belongs_to :track
  belongs_to :artist

  validates :role, presence: true
  validates :name, presence: true, uniqueness: {scope: %i[track artist role]}
  validates :track, presence: true
  validates :artist, presence: true
  validates :order, presence: true

  normalized_col_generator :name
end
