require 'test_helper'

class AuthTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, password: 'password')
  end

  test 'should get index' do
    sign_in_as(@user)

    expected_etag = construct_etag(AuthToken.where(user: @user).order(id: :asc))

    get auth_tokens_url

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should get index and return not modified if etag matches' do
    sign_in_as(@user)

    expected_etag = construct_etag(AuthToken.where(user: @user).order(id: :asc))

    get auth_tokens_url, headers: { 'If-None-Match': expected_etag }

    assert_response :not_modified
    assert_empty response.parsed_body
  end

  test 'should get index and include page in etag' do
    sign_in_as(@user)

    expected_etag = construct_etag(AuthToken.where(user: @user).order(id: :asc), page: 5, per_page: 501)

    get auth_tokens_url(page: 5, per_page: 501)

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should create auth_token and return token to authenticate' do
    assert_difference('AuthToken.count', 1) do
      post auth_tokens_url, params: {
        name: @user.name,
        password: @user.password,
        auth_token: { user_agent: 'Rails Test' }
      }
    end

    token = @response.parsed_body['token']

    assert_response :created
    assert_equal AuthToken.last, AuthToken.find_by_token_for(:api, token)
  end

  test 'should not create auth_token with wrong credentials' do
    assert_difference('AuthToken.count', 0) do
      post auth_tokens_url, params: {
        name: @user.name,
        password: "#{@user.password}a",
        auth_token: { user_agent: 'Rails Test' }
      }
    end

    assert_response :unauthorized
  end

  test 'should not create auth_token without user_agent' do
    assert_difference('AuthToken.count', 0) do
      post auth_tokens_url, params: {
        name: @user.name,
        password: @user.password
      }
    end

    assert_response :unprocessable_content
  end

  test 'should show auth_token' do
    sign_in_as(@user)
    auth_token = create(:auth_token, user: @user)
    get auth_token_url(auth_token)

    assert_response :success
  end

  test 'should destroy auth_token' do
    sign_in_as(@user)
    auth_token = create(:auth_token, user: @user)
    assert_difference('AuthToken.count', -1) do
      delete auth_token_url(auth_token)
    end

    assert_response :no_content
  end
end
