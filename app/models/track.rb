# == Schema Information
#
# Table name: tracks
#
#  id               :bigint           not null, primary key
#  normalized_title :string           not null
#  number           :integer          not null
#  review_comment   :string
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  album_id         :bigint           not null
#  audio_file_id    :bigint
#

class Track < ApplicationRecord
  include HasNormalized

  belongs_to :audio_file, optional: true, dependent: :destroy
  belongs_to :album
  has_and_belongs_to_many :genres
  has_many :track_artists, dependent: :destroy
  has_many :artists, through: :track_artists, source: :artist
  has_many :plays, dependent: :destroy
  has_many :playlist_items, as: :item, dependent: :destroy
  has_many :playlists, through: :playlist_items, source: :playlist

  validates :title, presence: true
  validates :number, presence: true

  normalized_col_generator :title

  before_save :normalize_artist_order
  nilify_blank_values :review_comment

  scope :by_filter, ->(filter) { where('"tracks"."normalized_title" LIKE ?', "%#{Track.normalize(filter)}%") }
  scope :by_artist, ->(artist) { joins(:artists).where(artists: { id: artist }) }
  scope :by_album, ->(album) { where(album:) }
  scope :by_genre, ->(genre) { joins(:genres).where(genres: { id: genre }) }

  def merge(other)
    af = other.audio_file
    # rubocop:disable Rails/SkipsModelValidations
    # Since we only update the track_id, there aren't any validations that could fail
    other.plays.update_all(track_id: id)
    # rubocop:enable Rails/SkipsModelValidations

    other.playlist_items.find_each do |item|
      item.update(item_id: id) unless playlist_items.where(playlist_id: item.playlist_id).any?
    end

    other.update(audio_file: nil)
    other.destroy
    return if af.blank?

    audio_file.destroy if audio_file_id?
    update(audio_file: af)
  end

  private

  def normalize_artist_order
    track_artists.sort { |ta1, ta2| ta1.order <=> ta2.order }.map.with_index(1) do |ta, i|
      ta.order = i
      ta.save unless ta.new_record?
    end
  end
end
