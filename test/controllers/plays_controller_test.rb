require 'test_helper'

class PlaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = create(:track)
    @user = create(:user)
    sign_in_as @user
  end

  test 'should get index with only plays for user' do
    create(:play, track: @track, user: create(:user))
    get plays_url

    assert_response :success
    body = response.parsed_body

    assert_empty body
  end

  test 'should get index with album scope' do
    play1 = create(:play, track: @track, user: @user)
    play2 = create(:play, user: @user)
    get plays_url(album_id: @track.album_id)

    assert_response :success
    body = response.parsed_body

    assert_includes body, play1.as_json
    assert_not_includes body, play2.as_json
  end

  test 'should create play' do
    assert_difference('Play.count', 1) do
      post plays_url, params: { play: { played_at: DateTime.current, track_id: @track.id } }
    end

    assert_response :created
    assert_equal Play.first.user_id, @user.id
  end

  test 'should return error if invalid play' do
    assert_difference('Play.count', 0) do
      post plays_url, params: { play: { played_at: nil, track_id: @track.id } }
    end

    assert_response :unprocessable_content
  end

  test 'should get stats and  not return play stats for other users' do
    create(:play, track: @track, user: create(:user))
    get stats_plays_url

    assert_response :success
    body = response.parsed_body

    assert_empty body
  end

  test 'should get stats and  return play stats for users' do
    create(:play, track: @track, user: @user, played_at: DateTime.new(2022, 0o1, 0o2, 0o3, 0o4, 0o5))
    get stats_plays_url

    assert_response :success
    body = response.parsed_body

    assert_equal 1, body[0]['count']
    assert_equal '2022-01-02T03:04:05.000Z', body[0]['last_played_at']
  end

  test 'should get stats and filter plays by album' do
    create(:play, track: @track, user: @user)
    create(:play, track: create(:track), user: @user)
    get stats_plays_url(album_id: @track.album_id)

    assert_response :success
    body = response.parsed_body

    assert_equal 1, body.length
  end

  test 'should get stats and filter plays by date' do
    create(:play, track: @track, user: @user, played_at: 5.days.ago)
    create(:play, track: @track, user: @user, played_at: 3.days.ago)
    create(:play, track: @track, user: @user, played_at: DateTime.current)
    create(:play, track: @track, user: @user)
    get stats_plays_url(played_before: 2.days.ago, played_after: 4.days.ago)

    assert_response :success
    body = response.parsed_body

    assert_equal 1, body[0]['count']
  end

  test 'should get stats and filter plays by artist' do
    ta = create(:track_artist, track: @track)
    create(:play, track: @track, user: @user)
    create(:play, track: create(:track_artist).track, user: @user)
    get stats_plays_url(artist_id: ta.artist_id)

    assert_response :success
    body = response.parsed_body

    assert_equal 1, body.length
  end
end
