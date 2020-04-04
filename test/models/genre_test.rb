# == Schema Information
#
# Table name: genres
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#

require 'test_helper'

class GenreTest < ActiveSupport::TestCase
  test 'should automatically generate normalized_name' do
    genre = build(:genre, name: 'ïóùåAÁ')
    genre.save
    assert_not genre.normalized_name.nil?
    assert_equal 'iouaaa', genre.normalized_name
  end

  test 'should update tracks on merge' do
    genre1 = create(:genre)
    genre2 = create(:genre)
    track = create(:track, genres: [genre1])

    genre1.merge(genre2)
    updated_track = Track.find(track.id)
    assert_not updated_track.genres.include?(genre1)
    assert updated_track.genres.include?(genre2)
  end
end
