# == Schema Information
#
# Table name: locations
#
#  id   :bigint(8)        not null, primary key
#  path :string           not null
#

class Location < ApplicationRecord
  has_many :audio_files, dependent: :destroy

  validates :path, uniqueness: true
end
