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

  test 'should be able to merge genres' do
    genre1 = create(:genre)
    genre2 = create(:genre)

    assert genre2.merge(genre1)
  end

  test 'should be able to merge genres if track belongs to one' do
    genre1 = create(:genre)
    genre2 = create(:genre)
    track = create(:track, genres: [genre1])

    genre2.merge(genre1)
    assert_not track.reload.genres.include?(genre1)
    assert track.reload.genres.include?(genre2)
  end

  test 'should be able to merge genres if track belongs to both' do
    genre1 = create(:genre)
    genre2 = create(:genre)
    track = create(:track, genres: [genre1, genre2])

    genre2.merge(genre1)
    assert_not track.reload.genres.include?(genre1)
    assert track.reload.genres.include?(genre2)
  end

end
