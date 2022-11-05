# == Schema Information
#
# Table name: track_artists
#
#  id              :bigint           not null, primary key
#  hidden          :boolean          default(FALSE), not null
#  name            :string           not null
#  normalized_name :string           not null
#  order           :integer          not null
#  role            :integer          not null
#  artist_id       :bigint           not null
#  track_id        :bigint           not null
#

require 'test_helper'

class TrackArtistTest < ActiveSupport::TestCase
  test 'should automatically generate normalized_name' do
    track_artist = build(:track_artist, name: 'ïóùåAÁ')
    track_artist.save

    assert_not track_artist.normalized_name.nil?
    assert_equal 'iouaaa', track_artist.normalized_name
  end
end
