# == Schema Information
#
# Table name: image_types
#
#  id         :bigint           not null, primary key
#  extension  :string           not null
#  mimetype   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_image_types_on_extension  (extension) UNIQUE
#

class ImageType < ApplicationRecord
  validates :mimetype, presence: true
  validates :extension, presence: true, uniqueness: true

  has_many :images, dependent: :restrict_with_error
end
