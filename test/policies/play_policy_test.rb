require 'test_helper'

class PlayPolicyTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)

    @user_play = create(:play, user: @user)
    @moderator_play = create(:play, user: @moderator)
    @admin_play = create(:play, user: @admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, Play)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, Play)
    end
  end

  test 'users should see their own plays' do
    assert_scope_includes @user, @user_play
    assert_scope_not_includes @user, @moderator_play, @admin_play

    assert_scope_includes @moderator, @moderator_play
    assert_scope_not_includes @moderator, @user_play, @admin_play

    assert_scope_includes @admin, @admin_play
    assert_scope_not_includes @admin, @user_play, @moderator_play
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, Play, :index
    assert_permitted @moderator, Play, :index
    assert_permitted @admin, Play, :index
  end

  test 'all users should be allowed to create a play' do
    assert_permitted @user, Play, :create
    assert_permitted @moderator, Play, :create
    assert_permitted @admin, Play, :create
  end

  test 'all users should be allowed to see play stats' do
    assert_permitted @user, Play, :stats
    assert_permitted @moderator, Play, :stats
    assert_permitted @admin, Play, :stats
  end

  test 'all users should be allowed to set all attributes for a play' do
    assert_attributes_permitted @user, Play, %i[track_id played_at]
    assert_attributes_permitted @moderator, Play, %i[track_id played_at]
    assert_attributes_permitted @admin, Play, %i[track_id played_at]
  end
end
