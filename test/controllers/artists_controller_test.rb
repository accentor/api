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
      post artists_url, params: { artist: { name: @artist.name } }
    end

    assert_response :forbidden
  end

  test 'should create artist for moderator' do
    sign_in_as create(:moderator)
    artist = build :artist

    image = {
      data: Base64.encode64(File.read(Rails.root.join('test/files/image.jpg'))),
      filename: 'image.jpg',
      mimetype: 'image/jpeg'
    }

    assert_difference('Artist.count', 1) do
      post artists_url, params: { artist: { name: artist.name, image: image } }
    end

    assert_equal File.read(Rails.root.join('test/files/image.jpg')).bytes,
                 Artist.find(JSON.parse(@response.body)['id']).image.image.download.bytes

    assert_response :created
  end

  test 'should show artist' do
    get artist_url(@artist)
    assert_response :success
  end

  test 'should update review_comment for user' do
    patch artist_url(@artist), params: { artist: { review_comment: 'Comment' } }
    @artist.reload
    assert_equal 'Comment', @artist.review_comment
  end

  test 'should not update artist metadata for user' do
    patch artist_url(@artist), params: { artist: { name: 'Naam' } }
    @artist.reload
    assert_not_equal 'Naam', @artist.name
  end

  test 'should clear review_comment' do
    @artist.update(review_comment: 'test')
    patch artist_url(@artist), params: { artist: { review_comment: nil } }
    @artist.reload
    assert_nil @artist.review_comment
  end

  test 'should update artist for moderator' do
    sign_in_as create(:moderator)
    artist = create :artist

    image = {
      data: Base64.encode64(File.read(Rails.root.join('test/files/image.jpg'))),
      filename: 'image.jpg',
      mimetype: 'image/jpeg'
    }

    patch artist_url(artist), params: { artist: { image: image } }

    assert_equal File.read(Rails.root.join('test/files/image.jpg')).bytes,
                 Artist.find(artist.id).image.image.download.bytes

    assert_response :success
  end

  test 'should destroy previous image when image is replaced' do
    sign_in_as create(:moderator)
    artist = create :artist, :with_image

    image = {
      data: Base64.encode64(File.read(Rails.root.join('test/files/image.jpg'))),
      filename: 'image.jpg',
      mimetype: 'image/jpeg'
    }

    assert_difference('Image.count', 0) do
      patch artist_url(artist), params: { artist: { image: image } }
    end

    assert_equal File.read(Rails.root.join('test/files/image.jpg')).bytes,
                 Artist.find(artist.id).image.image.download.bytes

    assert_response :success
  end

  test 'should destroy previous image when image is cleared' do
    sign_in_as create(:moderator)
    artist = create :artist, :with_image

    image = {
      data: nil,
      filename: nil,
      mimetype: nil
    }

    assert_difference('Image.count', -1) do
      patch artist_url(artist), params: { artist: { image: image } }
    end

    assert_nil Artist.find(artist.id).image

    assert_response :success
  end

  test 'should not destroy artist for user' do
    assert_difference('Artist.count', 0) do
      delete artist_url(@artist)
    end

    assert_response :forbidden
  end

  test 'should destroy artist for moderator' do
    sign_in_as create(:moderator)
    assert_difference('Artist.count', -1) do
      assert_difference('Image.count', -1) do
        assert_difference('ActiveStorage::Blob.count', -1) do
          delete artist_url(@artist)
          perform_enqueued_jobs
        end
      end
    end

    assert_response :no_content
  end

  test 'should not destroy empty artists for user' do
    assert_difference('Artist.count', 0) do
      post destroy_empty_artists_url
    end

    assert_response :forbidden
  end

  test 'should destroy empty artists for moderator (track_artist)' do
    sign_in_as create(:moderator)

    artist2 = create :artist
    create :track_artist, artist: artist2

    assert_difference('Image.count', -1) do
      assert_difference('ActiveStorage::Blob.count', -1) do
        assert_difference('Artist.count', -1) do
          post destroy_empty_artists_url
          perform_enqueued_jobs
        end
      end
    end

    assert_response :no_content

    assert_not_nil Artist.find_by(id: artist2.id)
  end

  test 'should destroy empty artists for moderator (album_artist)' do
    sign_in_as create(:moderator)

    artist2 = create :artist
    create :album_artist, artist: artist2

    assert_difference('Image.count', -1) do
      assert_difference('ActiveStorage::Blob.count', -1) do
        assert_difference('Artist.count', -1) do
          post destroy_empty_artists_url
          perform_enqueued_jobs
        end
      end
    end

    assert_response :no_content

    assert_not_nil Artist.find_by(id: artist2.id)
  end

  test 'should not merge artists for user' do
    artist = create(:artist)

    assert_difference('Artist.count', 0) do
      post merge_artist_url(@artist, source_id: artist.id)
    end

    assert_response :forbidden
  end

  test 'should merge artists for moderator' do
    sign_in_as(create(:moderator))
    artist = create(:artist)

    assert_difference('Artist.count', -1) do
      post merge_artist_url(@artist, source_id: artist.id)
    end

    assert_response :success
  end
end
