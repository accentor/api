# == Schema Information
#
# Table name: album_labels
#
#  id               :bigint           not null, primary key
#  catalogue_number :string
#  album_id         :bigint           not null
#  label_id         :bigint           not null
#
class AlbumLabelSerializer < ActiveModel::Serializer
  attributes :label_id, :catalogue_number
end
