require 'test_helper'

class RescansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @runner = create(:rescan_runner)
    @moderator = create(:moderator)
    @user = create(:user)
    sign_in_as(@user)
  end

  test 'should get not index for user' do
    get rescans_url

    assert_response :forbidden
  end

  test 'should get index for moderator' do
    sign_in_as(@moderator)
    get rescans_url

    assert_response :success
  end

  test 'should get not show for user' do
    get rescan_url(@runner)

    assert_response :forbidden
  end

  test 'should get show for moderator' do
    sign_in_as(@moderator)
    get rescan_url(@runner)

    assert_response :success
  end

  test 'should not start rescan for user' do
    post rescan_url(@runner)

    assert_response :forbidden
  end

  test 'should start rescan' do
    sign_in_as(@moderator)
    prev = @runner.finished_at
    post rescan_url(@runner)

    assert_response :success
    @runner.reload

    # TDOD(chvp): Flaky tests?
    assert_not_equal prev, @runner.finished_at
  end

  test 'should not start all rescans for user' do
    post rescans_url

    assert_response :forbidden
  end

  test 'should start all rescans' do
    sign_in_as(@moderator)
    prev = @runner.finished_at
    post rescans_url

    assert_response :success
    @runner.reload

    # TDOD(chvp): Flaky tests?
    assert_not_equal prev, @runner.finished_at
  end
end
