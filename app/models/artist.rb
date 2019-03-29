# == Schema Information
#
# Table name: artists
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  image_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Artist < ApplicationRecord
  include HasImage

  validates :name, presence: true

  belongs_to :image, required: false, dependent: :destroy
end
