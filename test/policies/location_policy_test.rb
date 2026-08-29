require 'test_helper'

class LocationPolicyTest < ActiveSupport::TestCase
  setup do
    @location = create(:location)
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user and regular user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, Location)
    end

    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(@user, Location)
    end
  end

  test 'scope should not be created for signed-out user and regular user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, Location)
    end

    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(@user, Location)
    end
  end

  test 'moderator+ should see locations' do
    assert_scope_includes @moderator, @location
    assert_scope_includes @admin, @location
  end

  test 'moderator+ should be allowed to access index' do
    assert_permitted @moderator, Location, :index
    assert_permitted @admin, Location, :index
  end

  test 'moderator+ should be allowed to see a location' do
    assert_permitted @moderator, @location, :show
    assert_permitted @admin, @location, :show
  end

  test 'moderator+ should be allowed to create a location' do
    assert_permitted @moderator, Location, :create
    assert_permitted @admin, Location, :create
  end

  test 'moderator+ should be allowed to destroy a location' do
    assert_permitted @moderator, @location, :destroy
    assert_permitted @admin, @location, :destroy
  end

  test 'moderator+ should be allowed to set all attributes for a location' do
    assert_attributes_permitted @moderator, @location, %i[path]
    assert_attributes_permitted @admin, @location, %i[path]
  end
end
