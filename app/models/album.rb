# == Schema Information
#
# Table name: albums
#
#  id                  :bigint           not null, primary key
#  edition             :date
#  edition_description :string
#  normalized_title    :string           not null
#  release             :date             default(Thu, 01 Jan 0000), not null
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
  has_many :playlist_items, as: :item, dependent: :destroy
  has_many :playlists, through: :playlist_items, source: :playlist
  belongs_to :image, optional: true, dependent: :destroy

  before_validation :normalize_artist_order

  validates :title, presence: true
  validate :album_artist_separators

  normalized_col_generator :title
  nilify_blank_values :edition_description, :review_comment

  scope :by_filter, ->(filter) { where('"albums"."normalized_title" LIKE ?', "%#{Album.normalize(filter)}%") }
  scope :by_artist, ->(artist) { joins(:artists).where(artists: { id: artist }) }
  scope :by_label, ->(label) { joins(:album_labels).where(album_labels: { label_id: label }) }
  scope :by_labels, ->(labels) { joins(:album_labels).where(album_labels: { label_id: labels }) }

  def merge(other)
    other.tracks.find_each do |track|
      track.update(album_id: id)
    end

    other.playlist_items.find_each do |item|
      item.update(item_id: id) unless playlist_items.where(playlist_id: item.playlist_id).any?
    end

    # Copy over the image if other has one and the current album does not have one
    if other.image.present? && image.nil?
      image_id = other.image_id
      # rubocop:disable Rails/SkipsModelValidations
      # We have to skip validations and callbacks, so that the `Image` object doesn't get destroyed
      other.update_column(:image_id, nil)
      # rubocop:enable Rails/SkipsModelValidations
      update(image_id:)
    end

    # we have to reload to make sure the relations aren't cached anymore
    other.reload.destroy
  end

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
