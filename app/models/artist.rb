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

  scope :by_filter, ->(filter) { where('normalized_name LIKE ?', "%#{Artist.normalize(filter)}%") }
  scope :sorted, lambda { |key, direction|
    case key
    when 'name'
      order(normalized_name: direction || :asc).order(id: :desc)
    else
      order(id: direction || :desc)
    end
  }

  def merge(other)
    other.album_artists.find_each do |aa|
      aa.update(artist_id: id) unless albums.include?(aa.album)
    end
    other.track_artists.find_each do |ta|
      ta.update(artist_id: id) unless tracks.include?(ta.track) && track_artists.where(role: ta.role).present?
    end

    other.destroy
  end
end
