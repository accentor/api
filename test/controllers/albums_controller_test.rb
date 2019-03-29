require 'test_helper'

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @album = create :album, :with_image, :with_release
    sign_in_as create(:user)
  end

  test 'should get index' do
    get albums_url
    assert_response :success
  end

  test 'should not create album for user' do
    assert_difference('Album.count', 0) do
      post albums_url, params: {album: {albumartist: @album.albumartist, release: @album.release, title: @album.title}}
    end

    assert_response :unauthorized
  end

  test 'should create album for moderator' do
    sign_in_as create(:moderator)
    album = build :album, :with_release

    image = {
        data: Base64.encode64(File.read(Rails.root.join('test', 'files', 'image.jpg'))),
        filename: 'image.jpg',
        mimetype: 'image/jpeg'
    }

    assert_difference('Album.count', 1) do
      post albums_url, params: {album: {
          albumartist: album.albumartist,
          release: album.release,
          title: album.title,
          image: image
      }}
    end

    assert_equal File.read(Rails.root.join('test', 'files', 'image.jpg')).bytes,
                 Album.find(JSON.parse(@response.body)["id"]).image.image.download.bytes

    assert_response :created
  end

  test 'should show album' do
    get album_url(@album)
    assert_response :success
  end

  test 'should not update album for user' do
    patch album_url(@album), params: {album: {albumartist: @album.albumartist, release: @album.release, title: @album.title}}
    assert_response :unauthorized
  end

  test 'should update album for moderator' do
    sign_in_as create(:moderator)
    album = create :album, :with_release

    image = {
        data: Base64.encode64(File.read(Rails.root.join('test', 'files', 'image.jpg'))),
        filename: 'image.jpg',
        mimetype: 'image/jpeg'
    }

    patch album_url(album), params: {album: {image: image}}

    assert_equal File.read(Rails.root.join('test', 'files', 'image.jpg')).bytes,
                 Album.find(album.id).image.image.download.bytes

    assert_response :success
  end

  test 'should destroy previous image when image is replaced' do
    sign_in_as create(:moderator)
    album = create :album, :with_release, :with_image

    image = {
        data: Base64.encode64(File.read(Rails.root.join('test', 'files', 'image.jpg'))),
        filename: 'image.jpg',
        mimetype: 'image/jpeg'
    }

    assert_difference('Image.count', 0) do
      patch album_url(album), params: {album: {image: image}}
    end

    assert_equal File.read(Rails.root.join('test', 'files', 'image.jpg')).bytes,
                 Album.find(album.id).image.image.download.bytes

    assert_response :success
  end

  test 'should not destroy album for user' do
    assert_difference('Album.count', 0) do
      delete album_url(@album)
    end

    assert_response :unauthorized
  end

  test 'should destroy album for moderator' do
    sign_in_as create(:moderator)
    assert_difference('Album.count', -1) do
      delete album_url(@album)
    end

    assert_equal 0, Image.count
    assert_equal 0, ActiveStorage::Blob.count

    assert_response :no_content
  end
end
