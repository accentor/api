# == Schema Information
#
# Table name: image_types
#
#  id        :bigint           not null, primary key
#  extension :string           not null
#  mimetype  :string           not null
#
# Indexes
#
#  index_image_types_on_extension  (extension) UNIQUE
#

require 'test_helper'

class ImageTypeTest < ActiveSupport::TestCase
end
