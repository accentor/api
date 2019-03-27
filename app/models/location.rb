# == Schema Information
#
# Table name: locations
#
#  id   :bigint(8)        not null, primary key
#  path :string           not null
#

class Location < ApplicationRecord
  validates :path, uniqueness: true
end
