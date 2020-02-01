# == Schema Information
#
# Table name: locations
#
#  id   :bigint           not null, primary key
#  path :string           not null
#
# Indexes
#
#  index_locations_on_path  (path) UNIQUE
#

require 'test_helper'

class LocationTest < ActiveSupport::TestCase
end
