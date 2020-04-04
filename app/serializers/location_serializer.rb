# == Schema Information
#
# Table name: locations
#
#  id   :bigint           not null, primary key
#  path :string           not null
#
class LocationSerializer < ActiveModel::Serializer
  attributes :id, :path
end
