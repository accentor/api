require 'test_helper'

class AuthTokenPolicyTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
    @user_auth_token = create(:auth_token, user: @user)
    @moderator_auth_token = create(:auth_token, user: @moderator)
    @admin_auth_token = create(:auth_token, user: @admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, AuthToken)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, AuthToken)
    end
  end

  test 'users should only see their own auth tokens' do
    assert_scope_includes @user, @user_auth_token
    assert_scope_not_includes @user, @moderator_auth_token, @admin_auth_token

    assert_scope_includes @moderator, @moderator_auth_token
    assert_scope_not_includes @moderator, @user_auth_token, @admin_auth_token

    assert_scope_includes @admin, @admin_auth_token
    assert_scope_not_includes @admin, @user_auth_token, @moderator_auth_token
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, AuthToken, :index
    assert_permitted @moderator, AuthToken, :index
    assert_permitted @admin, AuthToken, :index
  end

  test 'all users should be allowed to access only their auth token' do
    assert_permitted @user, @user_auth_token, :show
    assert_not_permitted @user, @moderator_auth_token, :show
    assert_not_permitted @user, @admin_auth_token, :show

    assert_not_permitted @moderator, @user_auth_token, :show
    assert_permitted @moderator, @moderator_auth_token, :show
    assert_not_permitted @moderator, @admin_auth_token, :show

    assert_not_permitted @admin, @user_auth_token, :show
    assert_not_permitted @admin, @moderator_auth_token, :show
    assert_permitted @admin, @admin_auth_token, :show
  end

  test 'all users should be allowed to destroy only their auth token' do
    assert_permitted @user, @user_auth_token, :destroy
    assert_not_permitted @user, @moderator_auth_token, :destroy
    assert_not_permitted @user, @admin_auth_token, :destroy

    assert_not_permitted @moderator, @user_auth_token, :destroy
    assert_permitted @moderator, @moderator_auth_token, :destroy
    assert_not_permitted @moderator, @admin_auth_token, :destroy

    assert_not_permitted @admin, @user_auth_token, :destroy
    assert_not_permitted @admin, @moderator_auth_token, :destroy
    assert_permitted @admin, @admin_auth_token, :destroy
  end
end
