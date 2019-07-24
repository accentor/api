# == Schema Information
#
# Table name: track_artists
#
#  id        :bigint           not null, primary key
#  track_id  :bigint           not null
#  artist_id :bigint           not null
#  name      :string           not null
#  role      :integer          not null
#  order     :integer          not null
#

require 'test_helper'

class TrackArtistTest < ActiveSupport::TestCase
end
