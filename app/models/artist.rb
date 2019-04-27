# == Schema Information
#
# Table name: artists
#
#  id             :bigint(8)        not null, primary key
#  name           :string           not null
#  image_id       :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  review_comment :string
#

class Artist < ApplicationRecord
  include HasImage

  belongs_to :image, required: false, dependent: :destroy
  has_many :track_artists, dependent: :destroy
  has_many :tracks, through: :track_artists, source: :track
  has_many :album_artists, dependent: :destroy
  has_many :albums, through: :album_artists, source: :album

  validates :name, presence: true
end
