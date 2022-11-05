# == Schema Information
#
# Table name: album_artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#  order           :integer          not null
#  separator       :string
#  album_id        :bigint           not null
#  artist_id       :bigint           not null
#

require 'test_helper'

class AlbumArtistTest < ActiveSupport::TestCase
  test 'should automatically generate normalized_name' do
    album_artist = build(:album_artist, name: 'ïóùåAÁ')
    album_artist.save

    assert_not album_artist.normalized_name.nil?
    assert_equal 'iouaaa', album_artist.normalized_name
  end
end
