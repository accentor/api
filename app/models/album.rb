# == Schema Information
#
# Table name: albums
#
#  id             :bigint(8)        not null, primary key
#  title          :string           not null
#  image_id       :bigint(8)
#  release        :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  review_comment :string
#

class Album < ApplicationRecord
  include HasImage

  has_many :album_labels, dependent: :destroy
  has_many :labels, through: :album_labels, source: :label
  has_many :tracks, dependent: :restrict_with_error
  has_many :album_artists, dependent: :destroy
  has_many :artists, through: :album_artists, source: :artist
  belongs_to :image, optional: true, dependent: :destroy

  before_validation :normalize_artist_order

  validates :title, presence: true
  validate :album_artist_separators

  scope :by_label, ->(label) {joins(:album_labels).where(album_labels: {label_id: label})}
  scope :by_labels, ->(labels) {joins(:album_labels).where(album_labels: {label_id: labels})}

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
      if aa.order == album_artists.count
        errors.add(:album_artists, "Last album artist should not have separator") unless aa.separator.nil?
      else
        errors.add(:album_artists, "Album artists (except last) should have separator") unless aa.separator.present?
      end
    end
  end
end
