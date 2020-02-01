# == Schema Information
#
# Table name: artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  image_id        :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  review_comment  :string
#  normalized_name :string           not null
#

class Artist < ApplicationRecord
  include HasImage
  include HasNormalized

  belongs_to :image, required: false, dependent: :destroy
  has_many :track_artists, dependent: :destroy
  has_many :tracks, through: :track_artists, source: :track
  has_many :album_artists, dependent: :destroy
  has_many :albums, through: :album_artists, source: :album

  validates :name, presence: true

  normalized_col_generator :name
end
