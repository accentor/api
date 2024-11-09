# == Schema Information
#
# Table name: cover_filenames
#
#  id       :bigint           not null, primary key
#  filename :string           not null
#
# Indexes
#
#  index_cover_filenames_on_filename  (filename) UNIQUE
#
class CoverFilenameSerializer < ActiveModel::Serializer
  attributes :id, :filename
end
