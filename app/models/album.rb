# == Schema Information
#
# Table name: albums
#
#  id          :bigint(8)        not null, primary key
#  title       :string           not null
#  albumartist :string           not null
#  image_id    :bigint(8)
#  release     :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Album < ApplicationRecord
  include HasImage

  has_many :album_labels, dependent: :destroy
  has_many :labels, through: :album_labels, source: :label
  has_many :tracks, dependent: :restrict_with_error
  belongs_to :image, optional: true, dependent: :destroy

  validates :title, presence: true
  validates :albumartist, presence: true

  scope :by_label, ->(label) {joins(:album_labels).where(album_labels: {label_id: label})}
  scope :by_labels, ->(labels) {joins(:album_labels).where(album_labels: {label_id: labels})}
end
