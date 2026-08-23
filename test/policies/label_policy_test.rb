require 'test_helper'

class LabelPolicyTest < ActiveSupport::TestCase
  setup do
    @label = create(:label)
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, Label)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, Label)
    end
  end

  test 'all users should see labels' do
    assert_scope_includes @user, @label
    assert_scope_includes @moderator, @label
    assert_scope_includes @admin, @label
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, Label, :index
    assert_permitted @moderator, Label, :index
    assert_permitted @admin, Label, :index
  end

  test 'all users should be allowed to see a label' do
    assert_permitted @user, @label, :show
    assert_permitted @moderator, @label, :show
    assert_permitted @admin, @label, :show
  end

  test 'only moderator+ should be allowed to create a label' do
    assert_not_permitted @user, Label, :create
    assert_permitted @moderator, Label, :create
    assert_permitted @admin, Label, :create
  end

  test 'only moderator+ should be allowed to update a label' do
    assert_not_permitted @user, @label, :update
    assert_permitted @moderator, @label, :update
    assert_permitted @admin, @label, :update
  end

  test 'only moderator+ should be allowed to destroy a label' do
    assert_not_permitted @user, @label, :destroy
    assert_permitted @moderator, @label, :destroy
    assert_permitted @admin, @label, :destroy
  end

  test 'only moderator+ should be allowed to destroy empty labels' do
    assert_not_permitted @user, Label, :destroy_empty
    assert_permitted @moderator, Label, :destroy_empty
    assert_permitted @admin, Label, :destroy_empty
  end

  test 'only moderator+ should be allowed to merge a label' do
    assert_not_permitted @user, @label, :merge
    assert_permitted @moderator, @label, :merge
    assert_permitted @admin, @label, :merge
  end

  test 'moderator+ should be allowed to change all attributes of a label' do
    assert_no_permitted_attributes @user, @label
    assert_attributes_permitted @moderator, @label, %i[name]
    assert_attributes_permitted @admin, @label, %i[name]
  end
end
