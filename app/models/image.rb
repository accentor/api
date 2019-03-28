class Image < ApplicationRecord
  has_one_attached :image
  belongs_to :image_type
end
