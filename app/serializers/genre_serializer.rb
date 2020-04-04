# == Schema Information
#
# Table name: genres
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#
class GenreSerializer < ActiveModel::Serializer
  attributes :id, :name, :normalized_name
end
