require 'test_helper'

class AuthTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, password: 'password')
  end

  test 'should get index' do
    sign_in_as(@user)
    get auth_tokens_url
    assert_response :success
  end

  test 'should create auth_token' do
    assert_difference('AuthToken.count', 1) do
      post auth_tokens_url, params: {
          name: @user.name,
          password: @user.password,
          auth_token: {user_agent: 'Rails Test'}
      }
    end

    assert_response 201
  end

  test 'should show auth_token' do
    sign_in_as(@user)
    auth_token = create :auth_token, user: @user
    get auth_token_url(auth_token)
    assert_response :success
  end

  test 'should destroy auth_token' do
    sign_in_as(@user)
    auth_token = create :auth_token, user: @user
    assert_difference('AuthToken.count', -1) do
      delete auth_token_url(auth_token)
    end

    assert_response 204
  end
end
