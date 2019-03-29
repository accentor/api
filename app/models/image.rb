# == Schema Information
#
# Table name: images
#
#  id            :bigint(8)        not null, primary key
#  image_type_id :bigint(8)        not null
#

class Image < ApplicationRecord
  has_one_attached :image
  belongs_to :image_type

  has_one :album

  validates :image, presence: true
  validates :image_type, presence: true
end
