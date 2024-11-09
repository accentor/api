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

require 'test_helper'

class ImageTest < ActiveSupport::TestCase
end
