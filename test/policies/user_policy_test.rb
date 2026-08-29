require 'test_helper'

class UserPolicyTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, User)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, User)
    end
  end

  test 'all users should see users' do
    assert_scope_includes @user, @user, @moderator, @admin
    assert_scope_includes @moderator, @user, @moderator, @admin
    assert_scope_includes @admin, @user, @moderator, @admin
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, User, :index
    assert_permitted @moderator, User, :index
    assert_permitted @admin, User, :index
  end

  test 'all users should be allowed to see all users' do
    assert_permitted @user, @user, :show
    assert_permitted @user, @moderator, :show
    assert_permitted @user, @admin, :show

    assert_permitted @moderator, @user, :show
    assert_permitted @moderator, @moderator, :show
    assert_permitted @moderator, @admin, :show

    assert_permitted @admin, @user, :show
    assert_permitted @admin, @moderator, :show
    assert_permitted @admin, @admin, :show
  end

  test 'only admin should be allowed to create a user' do
    assert_not_permitted @user, User, :create
    assert_not_permitted @moderator, User, :create
    assert_permitted @admin, User, :create
  end

  test 'users should be able to update themselves' do
    assert_permitted @user, @user, :update
    assert_permitted @moderator, @moderator, :update
    assert_permitted @admin, @admin, :update
  end

  test 'only admin should be able to update others' do
    assert_not_permitted @user, @moderator, :update
    assert_not_permitted @user, @admin, :update

    assert_not_permitted @moderator, @user, :update
    assert_not_permitted @moderator, @admin, :update

    assert_permitted @admin, @user, :update
    assert_permitted @admin, @moderator, :update
  end

  test 'users should be able to destroy themselves' do
    assert_permitted @user, @user, :destroy
    assert_permitted @moderator, @moderator, :destroy
    assert_permitted @admin, @admin, :destroy
  end

  test 'only admin should be able to destroy others' do
    assert_not_permitted @user, @moderator, :destroy
    assert_not_permitted @user, @admin, :destroy

    assert_not_permitted @moderator, @user, :destroy
    assert_not_permitted @moderator, @admin, :destroy

    assert_permitted @admin, @user, :destroy
    assert_permitted @admin, @moderator, :destroy
  end

  test 'all users should be allowed to set name, password and password confirmation' do
    assert_attributes_permitted @user, @user, %i[name password password_confirmation]
    assert_attributes_permitted @moderator, @moderator, %i[name password password_confirmation]
    assert_attributes_permitted @admin, @admin, %i[name password password_confirmation]
  end

  test 'only admin should be allowed to set permission' do
    assert_not_attributes_permitted @user, @user, :permission
    assert_not_attributes_permitted @moderator, @moderator, :permission
    assert_attributes_permitted @admin, @admin, :permission
  end
end
