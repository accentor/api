require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in_as(@user)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "admin should create user" do
    sign_in_as(create(:admin))
    user = build(:user)
    assert_difference('User.count') do
      post users_url, params: {user: {name: user.name, password: 'password', permission: user.permission}}
    end

    assert_response 201
  end

  test 'user shoud not create user' do
    user = build(:user)
    assert_difference('User.count', 0) do
      post users_url, params: {user: {name: user.name, password: 'password', permission: user.permission}}
    end

    assert_response 401
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should update own user" do
    patch user_url(@user), params: {user: {password: 'new_password'}}
    assert_response 200
  end

  test "should not update own permission if not admin" do
    patch user_url(@user), params: {user: {password: 'new_password', permission: :admin}}
    assert_not_equal :admin, @user.permission
    assert_response 200
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user), as: :json
    end

    assert_response 204
  end
end
