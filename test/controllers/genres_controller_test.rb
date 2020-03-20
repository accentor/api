require 'test_helper'

class GenresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @genre = create(:genre)
    sign_in_as(create(:user))
  end

  test 'should get index' do
    get genres_url
    assert_response :success
  end

  test 'should not create genre for user' do
    genre = build(:genre)
    assert_difference('Genre.count', 0) do
      post genres_url, params: { genre: { name: genre.name } }
    end

    assert_response :unauthorized
  end

  test 'should create genre for moderator' do
    sign_in_as(create(:moderator))
    genre = build(:genre)
    assert_difference('Genre.count', 1) do
      post genres_url, params: { genre: { name: genre.name } }
    end

    assert_response :created
  end

  test 'should create genre for admin' do
    sign_in_as(create(:admin))
    genre = build(:genre)
    assert_difference('Genre.count', 1) do
      post genres_url, params: { genre: { name: genre.name } }
    end

    assert_response :created
  end

  test 'should show genre' do
    get genre_url(@genre)
    assert_response :success
  end

  test 'should not update genre for user' do
    patch genre_url(@genre), params: { genre: { name: @genre.name } }
    assert_response 401
  end

  test 'should update genre for moderator' do
    sign_in_as(create(:moderator))
    patch genre_url(@genre), params: { genre: { name: @genre.name } }
    assert_response 200
  end

  test 'should update genre for admin' do
    sign_in_as(create(:admin))
    patch genre_url(@genre), params: { genre: { name: @genre.name } }
    assert_response 200
  end

  test 'should not destroy genre for user' do
    assert_difference('Genre.count', 0) do
      delete genre_url(@genre)
    end

    assert_response 401
  end

  test 'should destroy genre for moderator' do
    sign_in_as(create(:moderator))
    assert_difference('Genre.count', -1) do
      delete genre_url(@genre)
    end

    assert_response 204
  end

  test 'should destroy genre for admin' do
    sign_in_as(create(:admin))
    assert_difference('Genre.count', -1) do
      delete genre_url(@genre)
    end

    assert_response 204
  end

  test 'should not destroy empty genres for user' do
    assert_difference('Genre.count', 0) do
      post destroy_empty_genres_url
    end

    assert_response :unauthorized
  end

  test 'should destroy empty genres for moderator' do
    sign_in_as(create(:moderator))
    genre2 = create :genre
    track = create :track
    track.update(genres: [genre2])

    assert_difference('Genre.count', -1) do
      post destroy_empty_genres_url
    end

    assert_response :no_content

    assert_not_nil Genre.find_by(id: genre2.id)
  end

  test 'should destroy empty genres for admin' do
    sign_in_as(create(:admin))
    genre2 = create :genre
    track = create :track
    track.update(genres: [genre2])

    assert_difference('Genre.count', -1) do
      post destroy_empty_genres_url
    end

    assert_response :no_content

    assert_not_nil Genre.find_by(id: genre2.id)
  end
end
