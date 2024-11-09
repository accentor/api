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
class LocationSerializer < ActiveModel::Serializer
  attributes :id, :path
end
