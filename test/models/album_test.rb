# == Schema Information
#
# Table name: albums
#
#  id                  :bigint           not null, primary key
#  title               :string           not null
#  image_id            :bigint
#  release             :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  review_comment      :string
#  edition             :date
#  edition_description :string
#

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
end
