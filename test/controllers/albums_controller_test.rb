require 'test_helper'

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @album = create(:album, :with_image)
    sign_in_as create(:user)
  end

  test 'should get index' do
    expected_etag = "W/\"#{ActiveSupport::Digest.hexdigest(Album.order(id: :desc).cache_key_with_version)}\""

    get albums_url

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should get index and return not modified if etag matches' do
    expected_etag = "W/\"#{ActiveSupport::Digest.hexdigest(Album.order(id: :desc).cache_key_with_version)}\""

    get albums_url, headers: { 'If-None-Match': expected_etag }

    assert_response :not_modified
    assert_empty response.parsed_body
  end

  test 'should get index and include page in etag' do
    expected_etag = "W/\"#{ActiveSupport::Digest.hexdigest(ActiveSupport::Cache.expand_cache_key([Album.order(id: :desc).cache_key_with_version, 5, 501]))}\""

    get albums_url(page: 5, per_page: 501)

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should not create album for user' do
    assert_difference('Album.count', 0) do
      post albums_url, params: { album: { release: @album.release, title: @album.title } }
    end

    assert_response :forbidden
  end

  test 'should create album for moderator' do
    sign_in_as create(:moderator)
    album = build(:album)

    image = {
      data: Base64.encode64(Rails.root.join('test/files/image.jpg').read),
      filename: 'image.jpg',
      mimetype: 'image/jpeg'
    }

    assert_difference('Album.count', 1) do
      post albums_url, params: { album: {
        release: album.release,
        title: album.title,
        image:
      } }
    end

    assert_equal Rails.root.join('test/files/image.jpg').read.bytes,
                 Album.find(JSON.parse(@response.body)['id']).image.image.download.bytes

    assert_response :created
  end

  test 'should not create album without title' do
    sign_in_as create(:moderator)
    album = build(:album)

    assert_difference('Album.count', 0) do
      post albums_url, params: { album: { release: album.release } }
    end

    assert_response :unprocessable_content
  end

  test 'should create dependent album_labels' do
    sign_in_as create(:moderator)
    album = build(:album)

    album_labels = (1..5).map do |_|
      {
        label_id: create(:label).id,
        catalogue_number: Faker::Lorem.word
      }
    end

    assert_difference('Album.count', 1) do
      post albums_url, params: { album: {
        release: album.release,
        title: album.title,
        album_labels:
      } }
    end

    assert_equal album_labels.count,
                 Album.find(JSON.parse(@response.body)['id']).album_labels.count

    assert_response :created
  end

  test 'should create dependent album_artists' do
    sign_in_as create(:moderator)
    album = build(:album)

    album_artists = (1..5).map do |i|
      {
        artist_id: create(:artist).id,
        name: 'name',
        order: i,
        separator: i == 5 ? nil : ' / '
      }
    end

    assert_difference('Album.count', 1) do
      post albums_url, params: { album: {
        release: album.release,
        title: album.title,
        album_artists:
      } }
    end

    assert_equal album_artists.count,
                 Album.find(JSON.parse(@response.body)['id']).album_artists.count

    assert_response :created
  end

  test 'should show album' do
    get album_url(@album)

    assert_response :success
  end

  test 'should update review comment for user' do
    patch album_url(@album), params: { album: { review_comment: 'comment' } }
    @album.reload

    assert_equal 'comment', @album.review_comment
  end

  test 'should not update album metadata for user' do
    patch album_url(@album), params: { album: { release: @album.release, title: 'Titel' } }
    @album.reload

    assert_not_equal 'Titel', @album.title
  end

  test 'should not update album metadata to empty title' do
    sign_in_as create(:moderator)
    patch album_url(@album), params: { album: { release: @album.release, title: '' } }

    assert_response :unprocessable_content
    @album.reload

    assert_not_equal '', @album.title
  end

  test 'should clear review comment' do
    @album.update(review_comment: 'test')
    patch album_url(@album), params: { album: { review_comment: nil } }
    @album.reload

    assert_nil @album.review_comment
  end

  test 'should update album for moderator' do
    sign_in_as create(:moderator)
    album = create(:album)

    image = {
      data: Base64.encode64(Rails.root.join('test/files/image.jpg').read),
      filename: 'image.jpg',
      mimetype: 'image/jpeg'
    }

    patch album_url(album), params: { album: { image: } }

    assert_equal Rails.root.join('test/files/image.jpg').read.bytes,
                 Album.find(album.id).image.image.download.bytes

    assert_response :success
  end

  test 'should destroy previous image when image is replaced' do
    sign_in_as create(:moderator)
    album = create(:album, :with_image)

    image = {
      data: Base64.encode64(Rails.root.join('test/files/image.jpg').read),
      filename: 'image.jpg',
      mimetype: 'image/jpeg'
    }

    assert_difference('Image.count', 0) do
      patch album_url(album), params: { album: { image: } }
    end

    assert_equal Rails.root.join('test/files/image.jpg').read.bytes,
                 Album.find(album.id).image.image.download.bytes

    assert_response :success
  end

  test 'should destroy previous image when image is cleared' do
    sign_in_as create(:moderator)
    album = create(:album, :with_image)

    image = {
      data: nil,
      filename: nil,
      mimetype: nil
    }

    assert_difference('Image.count', -1) do
      patch album_url(album), params: { album: { image: } }
    end

    assert_nil Album.find(album.id).image

    assert_response :success
  end

  test 'should not destroy album for user' do
    assert_difference('Album.count', 0) do
      delete album_url(@album)
    end

    assert_response :forbidden
  end

  test 'should destroy album for moderator' do
    sign_in_as create(:moderator)
    assert_difference('Image.count', -1) do
      assert_difference('ActiveStorage::Blob.count', -1) do
        assert_difference('Album.count', -1) do
          delete album_url(@album)
          perform_enqueued_jobs
        end
      end
    end

    assert_response :no_content
  end

  test 'should not destroy empty albums for user' do
    assert_difference('Album.count', 0) do
      post destroy_empty_albums_url
    end

    assert_response :forbidden
  end

  test 'should destroy empty albums for moderator' do
    sign_in_as create(:moderator)
    album2 = create(:album)
    create(:track, album: album2)
    assert_difference('Image.count', -1) do
      assert_difference('ActiveStorage::Blob.count', -1) do
        assert_difference('Album.count', -1) do
          post destroy_empty_albums_url
          perform_enqueued_jobs
        end
      end
    end

    assert_response :no_content

    assert_not_nil Album.find_by(id: album2.id)
  end

  test 'should not merge albums for user' do
    album = create(:album)

    assert_difference('Album.count', 0) do
      post merge_album_url(@album, source_id: album.id)
    end

    assert_response :forbidden
  end

  test 'should merge albums for moderator' do
    sign_in_as(create(:moderator))
    album = create(:album)

    assert_difference('Album.count', -1) do
      post merge_album_url(@album, source_id: album.id)
    end

    assert_response :success
  end
end
