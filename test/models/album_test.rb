# == Schema Information
#
# Table name: albums
#
#  id             :bigint(8)        not null, primary key
#  title          :string           not null
#  image_id       :bigint(8)
#  release        :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  review_comment :string
#

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
end
