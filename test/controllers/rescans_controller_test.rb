require 'test_helper'

class RescansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @runner = create(:rescan_runner)
    @moderator = create(:moderator)
    @user = create(:user)
    sign_in_as(@user)
  end

  test 'should not get index for user' do
    get rescans_url

    assert_response :forbidden
  end

  test 'should get index for moderator' do
    sign_in_as @moderator
    expected_etag = construct_etag(RescanRunner.all)

    get rescans_url

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should get index for admin' do
    sign_in_as create(:admin)
    expected_etag = construct_etag(RescanRunner.all)

    get rescans_url

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should get index and return not modified if etag matches' do
    sign_in_as create(:admin)
    expected_etag = construct_etag(RescanRunner.all)

    get rescans_url, headers: { 'If-None-Match': expected_etag }

    assert_response :not_modified
    assert_empty response.parsed_body
  end

  test 'should get index and include page in etag' do
    sign_in_as create(:admin)
    expected_etag = construct_etag(RescanRunner.all, page: 5, per_page: 501)

    get rescans_url(page: 5, per_page: 501)

    assert_response :success
    assert_equal expected_etag, headers['etag']
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

    perform_enqueued_jobs

    @runner.reload

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

    perform_enqueued_jobs

    @runner.reload

    assert_not_equal prev, @runner.finished_at
  end
end
