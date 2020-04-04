# == Schema Information
#
# Table name: artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#  review_comment  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  image_id        :bigint
#

require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  test 'should automatically generate normalized_name' do
    artist = build(:artist, name: 'ïóùåAÁ')
    artist.save
    assert_not artist.normalized_name.nil?
    assert_equal 'iouaaa', artist.normalized_name
  end

  test 'should be able to merge artists' do
    artist1 = create(:artist)
    artist2 = create(:artist)

    assert_difference('Artist.count', -1) do
      artist2.merge(artist1)
    end
  end

  test 'should be able to merge artists if one has track_artist' do
    artist1 = create(:artist)
    artist2 = create(:artist)
    track = create(:track)
    create(:track_artist, track: track, artist: artist1)

    assert_difference('Artist.count', -1) do
      artist2.merge(artist1)
    end
    assert_not track.reload.artists.include?(artist1)
    assert track.reload.artists.include?(artist2)
  end

  test 'should be able to merge artists if both have track_artist' do
    artist1 = create(:artist)
    artist2 = create(:artist)
    track = create(:track)
    create(:track_artist, track: track, artist: artist1)
    create(:track_artist, track: track, artist: artist2)

    assert_difference('Artist.count', -1) do
      artist2.merge(artist1)
    end
    assert_not track.reload.artists.include?(artist1)
    assert track.reload.artists.include?(artist2)
  end

  test 'should be able to merge artists if one has album_artist' do
    artist1 = create(:artist)
    artist2 = create(:artist)
    album = create(:album)
    create(:album_artist, album: album, artist: artist1)

    assert_difference('Artist.count', -1) do
      artist2.merge(artist1)
    end
    assert_not album.reload.artists.include?(artist1)
    assert album.reload.artists.include?(artist2)
  end

  test 'should be able to merge artists if both have album_artist' do
    artist1 = create(:artist)
    artist2 = create(:artist)
    album = create(:album)
    create(:album_artist, album: album, artist: artist1)
    create(:album_artist, album: album, artist: artist2)

    assert_difference('Artist.count', -1) do
      artist2.merge(artist1)
    end
    assert_not album.reload.artists.include?(artist1)
    assert album.reload.artists.include?(artist2)
  end
end
