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
end
