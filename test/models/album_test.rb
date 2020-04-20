# == Schema Information
#
# Table name: albums
#
#  id                  :bigint           not null, primary key
#  edition             :date
#  edition_description :string
#  normalized_title    :string           not null
#  release             :date
#  review_comment      :string
#  title               :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image_id            :bigint
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
    assert album.valid?
  end

  test 'should reject if album artists except last has no separator' do
    album = build(:album, album_artists: [build(:album_artist, separator: nil, order: 1), build(:album_artist, separator: nil, order: 2)])
    assert_not album.valid?
    assert_not_empty album.errors[:album_artists]
  end

  test 'should allow album artists with empty string as separator' do
    album = build(:album, album_artists: [build(:album_artist, separator: '', order: 1), build(:album_artist, separator: nil, order: 2)])
    assert album.valid?
  end

  test 'should reject if last album artists has separator' do
    album = build(:album, album_artists: [build(:album_artist, separator: ' / ')])
    assert_not album.valid?
    assert_not_empty album.errors[:album_artists]
  end
end
