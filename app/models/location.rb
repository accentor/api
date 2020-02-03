# == Schema Information
#
# Table name: locations
#
#  id   :bigint           not null, primary key
#  path :string           not null
#

class Location < ApplicationRecord
  has_many :audio_files, dependent: :destroy

  validates :path, presence: true, uniqueness: true
end
