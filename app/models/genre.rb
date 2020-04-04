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
    other.tracks.find_each do |track|
      tracks << track unless tracks.include?(track)
    end
    other.destroy
  end
end
