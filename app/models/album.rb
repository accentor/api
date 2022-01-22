# == Schema Information
#
# Table name: albums
#
#  id                  :bigint           not null, primary key
#  edition             :date
#  edition_description :string
#  normalized_title    :string           not null
#  release             :date
#  review_comment      :string
#  title               :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image_id            :bigint
#

class Album < ApplicationRecord
  include HasImage
  include HasNormalized

  has_many :album_labels, dependent: :destroy
  has_many :labels, through: :album_labels, source: :label
  has_many :tracks, dependent: :restrict_with_error
  has_many :album_artists, dependent: :destroy
  has_many :artists, through: :album_artists, source: :artist
  belongs_to :image, optional: true, dependent: :destroy

  before_validation :normalize_artist_order

  validates :title, presence: true
  validate :album_artist_separators

  normalized_col_generator :title

  scope :by_filter, ->(filter) { where('"albums"."normalized_title" LIKE ?', "%#{Album.normalize(filter)}%") }
  scope :by_artist, ->(artist) { joins(:artists).where(artists: { id: artist }) }
  scope :by_label, ->(label) { joins(:album_labels).where(album_labels: { label_id: label }) }
  scope :by_labels, ->(labels) { joins(:album_labels).where(album_labels: { label_id: labels }) }

  private

  def normalize_artist_order
    album_artists.sort { |aa1, aa2| aa1.order <=> aa2.order }.map.with_index(1) do |aa, i|
      aa.order = i
      aa.save unless aa.new_record?
    end
  end

  def album_artist_separators
    album_artists.each do |aa|
      if aa.order == album_artists.to_a.count
        errors.add(:album_artists, 'aa-last-no-separator') unless aa.separator.nil?
      elsif aa.separator.nil?
        errors.add(:album_artists, 'aa-separator')
      end
    end
  end
end
