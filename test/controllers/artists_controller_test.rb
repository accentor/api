require 'test_helper'

class ArtistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = create :artist, :with_image
    sign_in_as create(:user)
  end

  test 'should get index' do
    get artists_url
    assert_response :success
  end

  test 'should not create artist for user' do
    assert_difference('Artist.count', 0) do
      post artists_url, params: {artist: {name: @artist.name}}
    end

    assert_response :unauthorized
  end

  test 'should create artist for moderator' do
    sign_in_as create(:moderator)
    artist = build :artist

    image = {
        data: Base64.encode64(File.read(Rails.root.join('test', 'files', 'image.jpg'))),
        filename: 'image.jpg',
        mimetype: 'image/jpeg'
    }

    assert_difference('Artist.count', 1) do
      post artists_url, params: {artist: {name: artist.name, image: image}}
    end

    assert_equal File.read(Rails.root.join('test', 'files', 'image.jpg')).bytes,
                 Artist.find(JSON.parse(@response.body)["id"]).image.image.download.bytes

    assert_response :created
  end

  test 'should show artist' do
    get artist_url(@artist)
    assert_response :success
  end

  test 'should not update artist for user' do
    patch artist_url(@artist), params: {artist: {name: @artist.name}}
    assert_response :unauthorized
  end

  test 'should update artist for moderator' do
    sign_in_as create(:moderator)
    artist = create :artist

    image = {
        data: Base64.encode64(File.read(Rails.root.join('test', 'files', 'image.jpg'))),
        filename: 'image.jpg',
        mimetype: 'image/jpeg'
    }

    patch artist_url(artist), params: {artist: {image: image}}

    assert_equal File.read(Rails.root.join('test', 'files', 'image.jpg')).bytes,
                 Artist.find(artist.id).image.image.download.bytes

    assert_response :success
  end

  test 'should destroy previous image when image is replaced' do
    sign_in_as create(:moderator)
    artist = create :artist, :with_image

    image = {
        data: Base64.encode64(File.read(Rails.root.join('test', 'files', 'image.jpg'))),
        filename: 'image.jpg',
        mimetype: 'image/jpeg'
    }

    assert_difference('Image.count', 0) do
      patch artist_url(artist), params: {artist: {image: image}}
    end

    assert_equal File.read(Rails.root.join('test', 'files', 'image.jpg')).bytes,
                 Artist.find(artist.id).image.image.download.bytes

    assert_response :success
  end

  test 'should not destroy artist for user' do
    assert_difference('Artist.count', 0) do
      delete artist_url(@artist)
    end

    assert_response :unauthorized
  end

  test 'should destroy artist for moderator' do
    sign_in_as create(:moderator)
    assert_difference('Artist.count', -1) do
      delete artist_url(@artist)
    end

    assert_equal 0, Image.count
    assert_equal 0, ActiveStorage::Blob.count

    assert_response :no_content
  end

  test 'should not destroy empty artists for user' do
    assert_difference('Artist.count', 0) do
      post destroy_empty_artists_url
    end

    assert_response :unauthorized
  end

  test 'should destroy empty artists for moderator' do
    sign_in_as create(:moderator)

    artist2 = create :artist
    track = create :track
    create :track_artist, track: track, artist: artist2

    assert_difference('Image.count', -1) do
      assert_difference('ActiveStorage::Blob.count', -1) do
        assert_difference('Artist.count', -1) do
          post destroy_empty_artists_url
        end
      end
    end

    assert_response :no_content

    assert_not_nil Artist.find_by(id: artist2.id)
  end
end
