# == Schema Information
#
# Table name: albums
#
#  id          :bigint(8)        not null, primary key
#  title       :string           not null
#  albumartist :string           not null
#  image_id    :bigint(8)
#  release     :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Album < ApplicationRecord
  include HasImage

  validates :title, presence: true
  validates :albumartist, presence: true

  belongs_to :image, optional: true, dependent: :destroy
end
