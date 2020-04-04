# == Schema Information
#
# Table name: cover_filenames
#
#  id       :bigint           not null, primary key
#  filename :string           not null
#
class CoverFilenameSerializer < ActiveModel::Serializer
  attributes :id, :filename
end
