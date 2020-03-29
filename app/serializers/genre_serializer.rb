class GenreSerializer < ActiveModel::Serializer
  attributes :id, :name, :normalized_name
end
