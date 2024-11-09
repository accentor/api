# == Schema Information
#
# Table name: images
#
#  id            :bigint           not null, primary key
#  image_type_id :bigint           not null
#
# Indexes
#
#  index_images_on_image_type_id  (image_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (image_type_id => image_types.id)
#

class Image < ApplicationRecord
  has_one_attached :image
  belongs_to :image_type

  has_one :album, required: false, dependent: :nullify
  has_one :artist, required: false, dependent: :nullify

  validates :image, presence: true
end
