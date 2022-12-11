# == Schema Information
#
# Table name: artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#  review_comment  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  image_id        :bigint
#

class Artist < ApplicationRecord
  include HasImage
  include HasNormalized

  belongs_to :image, optional: true, dependent: :destroy
  has_many :track_artists, dependent: :destroy
  has_many :tracks, through: :track_artists, source: :track
  has_many :album_artists, dependent: :destroy
  has_many :albums, through: :album_artists, source: :album
  has_many :playlist_items, as: :item, dependent: :destroy
  has_many :playlists, through: :playlist_items, source: :playlist

  validates :name, presence: true

  normalized_col_generator :name
  nilify_blank_values :review_comment

  scope :by_filter, ->(filter) { where('normalized_name LIKE ?', "%#{Artist.normalize(filter)}%") }

  def merge(other)
    # we check if the artist to be merged have some overlap. If they do, we tell the user that they should resolve this first.
    errors.add(:album_artists, 'aa.albums-overlap') if other.albums.map(&:id).intersect?(albums.map(&:id))
    errors.add(:track_artists, 'ta.tracks-overlap') if other.track_artists.map { |ta| [ta.track_id, ta.role] }.intersect?(track_artists.map { |ta| [ta.track_id, ta.role] })
    return false if errors.present?

    other.album_artists.find_each do |aa|
      aa.update(artist_id: id)
    end

    other.track_artists.find_each do |ta|
      ta.update(artist_id: id)
    end

    other.playlist_items.find_each do |item|
      item.update(item_id: id) unless playlist_items.where(playlist_id: item.playlist_id).any?
    end

    # we have to reload to make sure the track_artists and album_artists relation isn't cached anymore
    other.reload.destroy
  end
end
