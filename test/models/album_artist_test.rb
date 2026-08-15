# == Schema Information
#
# Table name: album_artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#  order           :integer          not null
#  separator       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  album_id        :bigint           not null
#  artist_id       :bigint           not null
#
# Indexes
#
#  index_album_artists_on_album_id                         (album_id)
#  index_album_artists_on_album_id_and_artist_id_and_name  (album_id,artist_id,name) UNIQUE
#  index_album_artists_on_artist_id                        (artist_id)
#  index_album_artists_on_normalized_name                  (normalized_name)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#  fk_rails_...  (artist_id => artists.id)
#

require 'test_helper'

class AlbumArtistTest < ActiveSupport::TestCase
  test 'should automatically generate normalized_name' do
    album_artist = build(:album_artist, name: 'ïóùåAÁ')
    album_artist.save

    assert_not album_artist.normalized_name.nil?
    assert_equal 'iouaaa', album_artist.normalized_name
  end

  test 'should be valid if all except last have separator' do
    album = build(:album, album_artists: [build(:album_artist, separator: ' / ', order: 1), build(:album_artist, separator: nil, order: 2)])
    album_artist1 = album.album_artists.first
    album_artist2 = album.album_artists.second

    assert_predicate album_artist1, :valid?
    assert_predicate album_artist2, :valid?
  end

  test 'should reject if album artists except last has no separator' do
    album = build(:album, album_artists: [build(:album_artist, separator: nil, order: 1), build(:album_artist, separator: nil, order: 2)])
    album_artist1 = album.album_artists.first
    album_artist2 = album.album_artists.second

    assert_not_predicate album_artist1, :valid?
    assert_predicate album_artist2, :valid?
    assert_error_of_kind album_artist1, :separator, :blank
  end

  test 'should allow album artists with empty string as separator' do
    album = build(:album, album_artists: [build(:album_artist, separator: '', order: 1), build(:album_artist, separator: nil, order: 2)])
    album_artist1 = album.album_artists.first
    album_artist2 = album.album_artists.second

    assert_predicate album_artist1, :valid?
    assert_predicate album_artist2, :valid?
  end

  test 'should reject if last album artists has separator' do
    album = build(:album, album_artists: [build(:album_artist, separator: ' / ')])
    album_artist1 = album.album_artists.first

    assert_not_predicate album_artist1, :valid?
    assert_error_of_kind album_artist1, :separator, :present
  end
end
