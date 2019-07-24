# == Schema Information
#
# Table name: artists
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  image_id       :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  review_comment :string
#

require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
end
