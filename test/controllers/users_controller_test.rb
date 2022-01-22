require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in_as(@user)
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should not create user for user' do
    user = build(:user)
    assert_difference('User.count', 0) do
      post users_url, params: { user: { name: user.name, password: 'password', permission: user.permission } }
    end

    assert_response :forbidden
  end

  test 'should not create user without name' do
    sign_in_as(create(:admin))
    user = build(:user)
    assert_difference('User.count', 0) do
      post users_url, params: { user: { password: 'password', permission: user.permission } }
    end

    assert_response :unprocessable_entity
  end

  test 'should create user for admin' do
    sign_in_as(create(:admin))
    user = build(:user)
    assert_difference('User.count') do
      post users_url, params: { user: { name: user.name, password: 'password', permission: user.permission } }
    end

    assert_response :created
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should update own user' do
    patch user_url(@user), params: { user: { name: 'new name' } }
    assert_response :ok
  end

  test 'should not update password without current password for current user' do
    patch user_url(@user), params: { user: { password: 'new password', current_password: 'not correct' } }
    assert_response :unauthorized
  end

  test 'should update password with current password for current user' do
    patch user_url(@user), params: { user: { current_password: @user.password, password: 'new password' } }
    assert_response :ok
  end

  test 'should update password for other user for admin' do
    sign_in_as(create(:admin))
    patch user_url(@user), params: { user: { password: 'new password' } }
    assert_response :ok
  end

  test 'should not update user to empty name' do
    sign_in_as(create(:admin))
    patch user_url(@user), params: { user: { name: '' } }
    assert_response :unprocessable_entity
    @user.reload
    assert_not_equal '', @user.name
  end

  test 'should not update own permission if not admin' do
    patch user_url(@user), params: { user: { permission: :admin } }
    assert_not_equal :admin, @user.permission
    assert_response :ok
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user), as: :json
    end

    assert_response :no_content
  end
end
