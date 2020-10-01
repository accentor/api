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

  validates :title, presence: true
  validates :number, presence: true

  normalized_col_generator :title

  before_save :normalize_artist_order

  scope :by_filter, ->(filter) { where('"tracks"."normalized_title" LIKE ?', "%#{Track.normalize(filter)}%") }
  scope :by_artist, ->(artist) { joins(:artists).where(artists: { id: artist }) }
  scope :by_album, ->(album) { where(album: album) }
  scope :by_genre, ->(genre) { joins(:genres).where(genres: { id: genre }) }
  scope :sorted, lambda { |key, direction|
    case key
    when 'album_title'
      joins(:album)
        .order('albums.normalized_title': direction || :asc)
        .order('albums.id': :desc)
        .order(number: :asc)
        .order(id: :desc)
    when 'album_added'
      joins(:album)
        .order('albums.id': direction || :desc)
        .order(number: :asc)
        .order(id: :desc)
    when 'album_released'
      joins(:album)
        .order('albums.release': direction || :desc)
        .order('albums.id': :desc)
        .order(number: :asc)
        .order(id: :desc)
    else
      order(id: direction || :desc)
    end
  }

  def merge(other)
    af = other.audio_file
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
