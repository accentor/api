class ImageTypeSerializer < ActiveModel::Serializer
  attributes :id, :extension, :mimetype
end
