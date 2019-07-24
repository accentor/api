# == Schema Information
#
# Table name: album_labels
#
#  id               :bigint           not null, primary key
#  album_id         :bigint           not null
#  label_id         :bigint           not null
#  catalogue_number :string           not null
#

class AlbumLabel < ApplicationRecord
  belongs_to :album
  belongs_to :label

  validates :catalogue_number, presence: true
  validates :album, uniqueness: {scope: :label}
end
