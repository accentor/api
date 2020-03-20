require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = create(:track, :with_audio_file)
    sign_in_as(create(:user))
  end

  test 'should get index' do
    get tracks_url
    assert_response :success
  end

  test 'should not create track for user' do
    assert_difference('Track.count', 0) do
      post tracks_url, params: { track: { album_id: @track.album_id, number: @track.number, title: @track.title } }
    end

    assert_response :forbidden
  end

  test 'should create track for moderator' do
    sign_in_as(create(:moderator))
    track = build(:track, album: @track.album)
    genres = create_list(:genre, 5)
    track_artists = (1..5).map do |_|
      {
        artist_id: create(:artist).id,
        name: Faker::Artist.name,
        role: TrackArtist.roles.to_a.sample[0]
      }
    end

    assert_difference('Track.count', 1) do
      post tracks_url, params: { track: {
        album_id: track.album_id,
        number: track.number,
        title: track.title,
        genre_ids: genres.map(&:id),
        track_artists: track_artists
      } }
    end

    assert_equal genres.count, Track.find(JSON.parse(@response.body)['id']).genres.count
    assert_equal track_artists.count, Track.find(JSON.parse(@response.body)['id']).track_artists.count

    assert_response :created
  end

  test 'should show track' do
    get track_url(@track)
    assert_response :success
  end

  test 'user should be able to update review_comment' do
    patch track_url(@track), params: { track: { review_comment: 'comment' } }
    assert_response :success
    @track.reload
    assert_equal 'comment', @track.review_comment
  end

  test 'should not update track metadata for user' do
    patch track_url(@track), params: { track: { album_id: @track.album_id, number: @track.number, title: @track.title } }
    assert_response :success
    @track.reload
    assert_not_equal :album_id, @track.album_id
  end

  test 'should clear review comment' do
    @track.update(review_comment: 'test')
    patch track_url(@track), params: { track: { review_comment: nil } }
    assert_response :success
    @track.reload
    assert_nil @track.review_comment
  end

  test 'should update track for moderator' do
    sign_in_as(create(:moderator))
    track = build(:track, album: @track.album)
    album = create(:album)

    patch track_url(@track), params: { track: { album_id: album.id, number: track.number, title: track.title } }
    assert_response :success
  end

  test 'should not destroy track for user' do
    assert_difference('Track.count', 0) do
      delete track_url(@track)
    end

    assert_response :forbidden
  end

  test 'should destroy track for moderator' do
    sign_in_as(create(:moderator))

    assert_difference('Track.count', -1) do
      delete track_url(@track)
    end

    assert_response :no_content
  end

  test 'should not destroy empty tracks for user' do
    assert_difference('Track.count', 0) do
      post destroy_empty_tracks_url
    end

    assert_response :forbidden
  end

  test 'should destroy empty tracks for moderator' do
    sign_in_as(create(:moderator))

    create :track

    assert_difference('Track.count', -1) do
      post destroy_empty_tracks_url
    end

    assert_response :no_content

    assert_not_nil Track.find_by(id: @track.id)
  end

  test 'should not merge tracks for user' do
    track = create(:track, :with_audio_file)

    assert_difference('Track.count', 0) do
      assert_difference('AudioFile.count', 0) do
        post merge_track_url(@track, other_track_id: track.id)
      end
    end

    assert_response :forbidden
  end

  test 'should merge tracks for moderator' do
    sign_in_as(create(:moderator))
    track = create(:track, :with_audio_file)

    assert_difference('Track.count', -1) do
      assert_difference('AudioFile.count', -1) do
        post merge_track_url(@track, other_track_id: track.id)
      end
    end

    assert_response :success
  end
end
