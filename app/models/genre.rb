# == Schema Information
#
# Table name: genres
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#

class Genre < ApplicationRecord
  include HasNormalized

  has_many :track_genres, dependent: :destroy
  has_many :tracks, through: :track_genres, source: :track

  validates :name, presence: true, uniqueness: true

  normalized_col_generator :name
end
