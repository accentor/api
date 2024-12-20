# == Schema Information
#
# Table name: genres
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#
# Indexes
#
#  index_genres_on_name             (name) UNIQUE
#  index_genres_on_normalized_name  (normalized_name)
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

    assert_difference('Genre.count', -1) do
      genre2.merge(genre1)
    end
  end

  test 'should be able to merge genres if track belongs to one' do
    genre1 = create(:genre)
    genre2 = create(:genre)
    track = create(:track, genres: [genre1])

    assert_difference('Genre.count', -1) do
      genre2.merge(genre1)
    end

    assert_not track.reload.genres.include?(genre1)
    assert_includes track.reload.genres, genre2
  end

  test 'should be able to merge genres if track belongs to both' do
    genre1 = create(:genre)
    genre2 = create(:genre)
    track = create(:track, genres: [genre1, genre2])

    assert_difference('Genre.count', -1) do
      genre2.merge(genre1)
    end

    assert_not track.reload.genres.include?(genre1)
    assert_includes track.reload.genres, genre2
  end
end
