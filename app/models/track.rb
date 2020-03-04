# == Schema Information
#
# Table name: tracks
#
#  id               :bigint           not null, primary key
#  title            :string           not null
#  number           :integer          not null
#  audio_file_id    :bigint
#  album_id         :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  review_comment   :string
#  normalized_title :string           not null
#

class Track < ApplicationRecord
  include HasNormalized

  belongs_to :audio_file, optional: true, dependent: :destroy
  belongs_to :album
  has_and_belongs_to_many :genres
  has_many :track_artists, dependent: :destroy
  has_many :artists, through: :track_artists, source: :artist

  validates :title, presence: true
  validates :number, presence: true

  normalized_col_generator :title

  before_save :normalize_artist_order

  scope :by_filter, ->(filter) {where('"tracks"."normalized_title" LIKE ?', "%#{Track.normalize(filter)}%")}
  scope :by_artist, ->(artist) {joins(:artists).where(artists: {id: artist})}
  scope :by_album, ->(album) {where(album: album)}
  scope :by_genre, ->(genre) {joins(:genres).where(genres: {id: genre})}

  def merge(other)
    af = other.audio_file
    other.update(audio_file: nil)
    other.destroy
    audio_file.destroy if audio_file_id?
    update(audio_file: af)
  end

  private

  def normalize_artist_order
    track_artists.sort do |ta1, ta2|
      return ta1.order <=> ta2.order unless (ta1.order <=> ta2.order).nil?
      if ta1.order.present?
        1
      elsif ta2.order.present?
        -1
      else
        0
      end
    end.map.with_index do |ta, i|
      ta.order = i + 1
      ta.save unless ta.new_record?
    end
  end

end
