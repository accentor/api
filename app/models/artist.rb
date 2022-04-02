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

  validates :name, presence: true

  normalized_col_generator :name
  nilify_blank_values :review_comment

  scope :by_filter, ->(filter) { where('normalized_name LIKE ?', "%#{Artist.normalize(filter)}%") }

  def merge(other)
    # we check if the artist to be merged have some overlap. If they do, we tell the user that they should resolve this first.
    errors.add(:album_artists, 'aa.albums-overlap') unless (other.albums.map(&:id) & albums.map(&:id)).empty?
    errors.add(:track_artists, 'ta.tracks-overlap') unless (other.track_artists.map { |ta| [ta.track_id, ta.role] } & track_artists.map { |ta| [ta.track_id, ta.role] }).empty?
    return false if errors.present?

    other.album_artists.find_each do |aa|
      aa.update(artist_id: id)
    end

    other.track_artists.find_each do |ta|
      ta.update(artist_id: id)
    end

    # we have to reload to make sure the track_artists and album_artists relation isn't cached anymore
    other.reload.destroy
  end
end
