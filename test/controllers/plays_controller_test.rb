require 'test_helper'

class PlaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = create(:track)
    @user = create(:user)
    sign_in_as @user
  end

  test 'should create play' do
    assert_difference('Play.count', 1) do
      post plays_url, params: { play: { played_at: DateTime.current, track_id: @track.id, user_id: @user.id } }
    end

    assert_response 201
  end
end
