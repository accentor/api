# == Schema Information
#
# Table name: images
#
#  id            :bigint           not null, primary key
#  image_type_id :bigint           not null
#

class Image < ApplicationRecord
  has_one_attached :image
  belongs_to :image_type

  has_one :album, required: false, dependent: :nullify
  has_one :artist, required: false, dependent: :nullify

  validates :image, presence: true
end
