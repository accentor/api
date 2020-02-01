# == Schema Information
#
# Table name: genres
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#
# Indexes
#
#  index_genres_on_name             (name) UNIQUE
#  index_genres_on_normalized_name  (normalized_name)
#

class Genre < ApplicationRecord
  include HasNormalized

  has_and_belongs_to_many :tracks

  validates :name, presence: true, uniqueness: true

  normalized_col_generator :name
end
