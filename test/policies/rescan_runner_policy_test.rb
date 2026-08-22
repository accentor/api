require 'test_helper'

class RescanRunnerPolicyTest < ActiveSupport::TestCase
  setup do
    @rescan_runner = create(:rescan_runner)
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user and regular user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, RescanRunner)
    end

    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(@user, RescanRunner)
    end
  end

  test 'scope should not be created for signed-out user and regular user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, RescanRunner)
    end

    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(@user, RescanRunner)
    end
  end

  test 'moderator+ should see rescan runners' do
    assert_scope_includes @moderator, @rescan_runner
    assert_scope_includes @admin, @rescan_runner
  end

  test 'moderator+ should be allowed to access index' do
    assert_permitted @moderator, RescanRunner, :index
    assert_permitted @admin, RescanRunner, :index
  end

  test 'moderator+ should be allowed to see a rescan runner' do
    assert_permitted @moderator, @rescan_runner, :show
    assert_permitted @admin, @rescan_runner, :show
  end

  test 'moderator+ should be allowed to start a rescan runner' do
    assert_permitted @moderator, @rescan_runner, :start
    assert_permitted @admin, @rescan_runner, :start
  end

  test 'moderator+ should be allowed to start all rescan runners' do
    assert_permitted @moderator, RescanRunner, :start_all
    assert_permitted @admin, RescanRunner, :start_all
  end
end
