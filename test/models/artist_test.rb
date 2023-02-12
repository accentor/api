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
    create(:track_artist, track:, artist: artist1)

    assert_not artist2.track_artists.present?

    assert_difference('Artist.count', -1) do
      assert_difference('TrackArtist.count', 0) do
        artist2.merge(artist1)
      end
    end

    assert_not track.reload.artists.include?(artist1)
    assert_includes track.reload.artists, artist2
  end

  test 'should not be able to merge artists if they share track_artist with same role' do
    artist1 = create(:artist)
    artist2 = create(:artist)
    track = create(:track)
    create(:track_artist, track:, artist: artist1, role: :main)
    create(:track_artist, track:, artist: artist2, role: :main)

    assert_difference('Artist.count', 0) do
      artist2.merge(artist1)
    end

    assert_not_empty artist2.errors[:track_artists]
  end

  test 'should be able to merge artists if they share track_artist with different role' do
    artist1 = create(:artist)
    artist2 = create(:artist)
    track = create(:track)
    create(:track_artist, track:, artist: artist1, role: :main)
    create(:track_artist, track:, artist: artist2, role: :performer)

    assert_difference('Artist.count', -1) do
      artist2.merge(artist1)
    end

    assert_not track.reload.artists.include?(artist1)
    assert_not_empty TrackArtist.where(track_id: track.id).where(artist_id: artist2.id).where(role: :main)
  end

  test 'should be able to merge artists if one has album_artist' do
    artist1 = create(:artist)
    artist2 = create(:artist)
    album = create(:album)
    create(:album_artist, album:, artist: artist1)

    assert_difference('Artist.count', -1) do
      artist2.merge(artist1)
    end

    assert_not album.reload.artists.include?(artist1)
    assert_includes album.reload.artists, artist2
  end

  test 'should be able to merge artists if one belongs to playlist' do
    artist1 = create(:artist)
    artist2 = create(:artist)
    playlist = create(:playlist, playlist_type: :artist)
    create(:playlist_item, item: artist1, playlist:)

    assert_difference('Artist.count', -1) do
      artist2.merge(artist1)
    end

    assert_not playlist.reload.item_ids.include? artist1.id
    assert_includes playlist.reload.item_ids, artist2.id
  end

  test 'should be able to merge artists if they belong to the same playlist' do
    artist1 = create(:artist)
    artist2 = create(:artist)
    playlist = create(:playlist, playlist_type: :artist)
    create(:playlist_item, item: artist1, playlist:)
    create(:playlist_item, item: artist2, playlist:)

    assert_difference(['Artist.count', 'PlaylistItem.count'], -1) do
      artist2.merge(artist1)
    end

    assert_not playlist.reload.item_ids.include? artist1.id
    assert_includes playlist.reload.item_ids, artist2.id
  end

  test 'should not be able to merge artists if they share album_artist' do
    artist1 = create(:artist)
    artist2 = create(:artist)
    album = create(:album)
    create(:album_artist, album:, artist: artist1)
    create(:album_artist, album:, artist: artist2)

    assert_difference('Artist.count', 0) do
      artist2.merge(artist1)
    end

    assert_not_empty artist2.errors[:album_artists]
  end

  test 'should keep not override image during merge' do
    artist1 = create(:artist, :with_image)
    artist2 = create(:artist, :with_image)

    assert_difference ['Image.count', 'ActiveStorage::Attachment.count'], -1 do
      artist2.merge(artist1)
    end

    assert_predicate artist2.image, :present?
  end

  test 'should keep image from other during merge if target doesnt have one' do
    artist1 = create(:artist, :with_image)
    artist2 = create(:artist)

    assert_no_difference 'Image.count', 'ActiveStorage::Attachment.count' do
      artist2.merge(artist1)
    end

    assert_predicate artist2.image, :present?
  end

  test 'should nilify blank review_comment' do
    track = build(:track, review_comment: '')
    track.save

    assert_nil track.review_comment
  end

  test 'should move playlist_items railon merge' do
    a1 = create(:artist)
    a2 = create(:artist)
    create(:playlist_item, :for_artist, item: a2)

    assert_no_difference('PlaylistItem.count') do
      a1.merge(a2)
    end

    assert_equal 1, Artist.count
    assert_equal 1, a1.playlist_items.count
  end
end
