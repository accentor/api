# == Schema Information
#
# Table name: track_artists
#
#  id        :bigint(8)        not null, primary key
#  track_id  :bigint(8)        not null
#  artist_id :bigint(8)        not null
#  name      :string           not null
#  role      :integer          not null
#

require 'test_helper'

class TrackArtistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
