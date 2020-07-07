require 'test_helper'

class RescanControllerTest < ActionDispatch::IntegrationTest
  setup do
    @moderator = create(:moderator)
    @user = create(:user)
    sign_in_as(@user)
  end

  test 'should get not show for user' do
    get rescan_url
    assert_response :forbidden
  end

  test 'should not create new runner if one exists' do
    RescanRunner.create
    sign_in_as(@moderator)
    assert_difference('RescanRunner.count', 0) do
      get rescan_url
    end
    assert_response :success
  end

  test 'should create RescanRunner if none exists for moderator' do
    sign_in_as(@moderator)
    assert_difference('RescanRunner.count', 1) do
      get rescan_url
    end
    assert_response :success
  end

  test 'should not start rescan for user' do
    post rescan_url
    assert_response :forbidden
  end

  test 'should start rescan' do
    @runner = RescanRunner.create
    sign_in_as(@moderator)
    prev = @runner.finished_at
    post rescan_url
    assert_response :success
    @runner.reload
    assert_not_equal prev, @runner.finished_at
  end
end
