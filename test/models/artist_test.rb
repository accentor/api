# == Schema Information
#
# Table name: artists
#
#  id             :bigint(8)        not null, primary key
#  name           :string           not null
#  image_id       :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  review_comment :string
#

require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
end
