# == Schema Information
#
# Table name: image_types
#
#  id        :bigint           not null, primary key
#  extension :string           not null
#  mimetype  :string           not null
#
class ImageTypeSerializer < ActiveModel::Serializer
  attributes :id, :extension, :mimetype
end
