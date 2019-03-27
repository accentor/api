# == Schema Information
#
# Table name: image_types
#
#  id        :bigint(8)        not null, primary key
#  extension :string           not null
#  mimetype  :string           not null
#

class ImageType < ApplicationRecord
  validates :mimetype, presence: true
  validates :extension, presence: true, uniqueness: true
end
