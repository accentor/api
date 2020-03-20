# == Schema Information
#
# Table name: album_labels
#
#  id               :bigint           not null, primary key
#  catalogue_number :string
#  album_id         :bigint           not null
#  label_id         :bigint           not null
#

class AlbumLabel < ApplicationRecord
  belongs_to :album
  belongs_to :label

  validates :album, uniqueness: { scope: :label }
end
