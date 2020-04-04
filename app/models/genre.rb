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

  has_and_belongs_to_many :tracks

  validates :name, presence: true, uniqueness: true

  normalized_col_generator :name

  def merge(other)
    tracks = self.tracks
    tracks.find_each do |track|
      track.genres << other unless track.genres.include?(other)
    end
    destroy
  end
end
