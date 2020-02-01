# == Schema Information
#
# Table name: locations
#
#  id   :bigint           not null, primary key
#  path :string           not null
#
# Indexes
#
#  index_locations_on_path  (path) UNIQUE
#

class Location < ApplicationRecord
  has_many :audio_files, dependent: :destroy

  validates :path, presence: true, uniqueness: true
end
