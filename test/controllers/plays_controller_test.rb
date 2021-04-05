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
    body = ActiveSupport::JSON.decode response.body
    assert_empty body
  end

  test 'should create play' do
    assert_difference('Play.count', 1) do
      post plays_url, params: { play: { played_at: DateTime.current, track_id: @track.id } }
    end

    assert_response 201
    assert_equal Play.first.user_id, @user.id
  end

  test 'should return error if invalid play' do
    assert_difference('Play.count', 0) do
      post plays_url, params: { play: { played_at: nil, track_id: @track.id } }
    end

    assert_response 422
  end
end
