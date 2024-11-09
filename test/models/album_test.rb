# == Schema Information
#
# Table name: albums
#
#  id                  :bigint           not null, primary key
#  edition             :date
#  edition_description :string
#  normalized_title    :string           not null
#  release             :date             default(Thu, 01 Jan 0000), not null
#  review_comment      :string
#  title               :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image_id            :bigint
#
# Indexes
#
#  index_albums_on_image_id          (image_id) UNIQUE
#  index_albums_on_normalized_title  (normalized_title)
#
# Foreign Keys
#
#  fk_rails_...  (image_id => images.id)
#

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  test 'should automatically generate normalized_title' do
    album = build(:album, title: 'ïóùåAÁ')
    album.save

    assert_not album.normalized_title.nil?
    assert_equal 'iouaaa', album.normalized_title
  end

  test 'should pass if all but last album artists have separator' do
    album = build(:album, album_artists: [build(:album_artist, separator: ' / ', order: 1), build(:album_artist, separator: nil, order: 2)])

    assert_predicate album, :valid?
  end

  test 'should reject if album artists except last has no separator' do
    album = build(:album, album_artists: [build(:album_artist, separator: nil, order: 1), build(:album_artist, separator: nil, order: 2)])

    assert_not album.valid?
    assert_not_empty album.errors[:album_artists]
  end

  test 'should allow album artists with empty string as separator' do
    album = build(:album, album_artists: [build(:album_artist, separator: '', order: 1), build(:album_artist, separator: nil, order: 2)])

    assert_predicate album, :valid?
  end

  test 'should reject if last album artists has separator' do
    album = build(:album, album_artists: [build(:album_artist, separator: ' / ')])

    assert_not album.valid?
    assert_not_empty album.errors[:album_artists]
  end

  test 'should normalize order of album artists' do
    aa1 = build(:album_artist, order: 5)
    aa2 = build(:album_artist, order: 2)
    album = build(:album, album_artists: [aa1, aa2])
    album.save

    assert_equal 2, aa1.order
    assert_equal 1, aa2.order
  end

  test 'should leave order of album artists alone if normalized' do
    aa1 = build(:album_artist, order: 1)
    aa2 = build(:album_artist, order: 2)
    album = build(:album, album_artists: [aa1, aa2])
    album.save

    assert_equal 1, aa1.order
    assert_equal 2, aa2.order
  end

  test 'should normalize order of album artists in order provided if equal' do
    aa1 = build(:album_artist, order: 0)
    aa2 = build(:album_artist, order: 0)
    album = build(:album, album_artists: [aa1, aa2])
    album.save

    assert_equal 1, aa1.order
    assert_equal 2, aa2.order
  end

  test 'should nilify blank edition descriptions' do
    album = build(:album, edition_description: '')
    album.save

    assert_nil album.edition_description
  end

  test 'should nilify blank review_comment' do
    album = build(:album, review_comment: '')
    album.save

    assert_nil album.review_comment
  end

  test 'should be able to merge albums' do
    album1 = create(:album)
    album2 = create(:album)

    assert_difference 'Album.count', -1 do
      album2.merge(album1)
    end
  end

  test 'should be able to merge albums if one has tracks' do
    album1 = create(:album)
    album2 = create(:album)
    track = create(:track, album: album1)

    assert_not album2.tracks.present?

    assert_difference 'Album.count', -1 do
      assert_no_difference 'Track.count' do
        album2.merge(album1)
      end
    end

    assert_not_equal album1, track.reload.album
    assert_equal album2, track.album
  end

  test 'should be able to merge albums if one belongs to playlist' do
    album1 = create(:album)
    album2 = create(:album)
    playlist = create(:playlist, playlist_type: :album)
    create(:playlist_item, item: album1, playlist:)

    assert_difference('Album.count', -1) do
      album2.merge(album1)
    end

    assert_not playlist.reload.item_ids.include? album1.id
    assert_includes playlist.reload.item_ids, album2.id
  end

  test 'should be able to merge albums if they belong to the same playlist' do
    album1 = create(:album)
    album2 = create(:album)
    playlist = create(:playlist, playlist_type: :album)
    create(:playlist_item, item: album1, playlist:)
    create(:playlist_item, item: album2, playlist:)

    assert_difference(['Album.count', 'PlaylistItem.count'], -1) do
      album2.merge(album1)
    end

    assert_not playlist.reload.item_ids.include? album1.id
    assert_includes playlist.reload.item_ids, album2.id
  end

  test 'should keep not override image during merge' do
    album1 = create(:album, :with_image)
    album2 = create(:album, :with_image)

    assert_difference ['Image.count', 'ActiveStorage::Attachment.count'], -1 do
      album2.merge(album1)
    end

    assert_predicate album2.image, :present?
  end

  test 'should keep image from other during merge if target doesnt have one' do
    album1 = create(:album, :with_image)
    album2 = create(:album)

    assert_no_difference 'Image.count', 'ActiveStorage::Attachment.count' do
      album2.merge(album1)
    end

    assert_predicate album2.image, :present?
  end
end
