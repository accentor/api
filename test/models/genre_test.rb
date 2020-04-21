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
    assert track.reload.genres.include?(genre2)
  end

  test 'should be able to merge genres if track belongs to both' do
    genre1 = create(:genre)
    genre2 = create(:genre)
    track = create(:track, genres: [genre1, genre2])

    assert_difference('Genre.count', -1) do
      genre2.merge(genre1)
    end
    assert_not track.reload.genres.include?(genre1)
    assert track.reload.genres.include?(genre2)
  end

  test 'should be able to search by id' do
    g1 = create(:genre)
    g2 = create(:genre)
    g3 = create(:genre)

    assert_equal [g1], Genre.by_ids(g1.id).to_a
    assert_equal [g1, g2], Genre.by_ids([g1.id, g2.id]).to_a
    assert_equal [g3], Genre.by_ids(g3.id).to_a
  end
end
