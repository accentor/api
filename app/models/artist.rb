# == Schema Information
#
# Table name: artists
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  image_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Artist < ApplicationRecord
  include HasImage

  belongs_to :image, required: false, dependent: :destroy
  has_many :track_artists, dependent: :destroy
  has_many :tracks, through: :track_artists, source: :track

  validates :name, presence: true
end
