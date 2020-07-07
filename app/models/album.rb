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
  scope :sorted, lambda { |key, direction|
    case key
    when 'title'
      order(normalized_title: direction || :asc).order(id: :desc)
    when 'released'
      order(release: direction || :desc).order(id: :desc)
    else
      order(id: :desc)
    end
  }

  private

  def normalize_artist_order
    album_artists.sort do |aa1, aa2|
      return aa1.order <=> aa2.order unless (aa1.order <=> aa2.order).nil?

      if aa1.order.present?
        1
      elsif aa2.order.present?
        -1
      else
        0
      end
    end.map.with_index do |aa, i|
      aa.order = i + 1
      aa.save unless aa.new_record?
    end
  end

  def album_artist_separators
    album_artists.each do |aa|
      if aa.order == album_artists.to_a.size
        errors.add(:album_artists, 'aa-last-no-separator') unless aa.separator.nil?
      elsif aa.separator.nil?
        errors.add(:album_artists, 'aa-separator')
      end
    end
  end
end
