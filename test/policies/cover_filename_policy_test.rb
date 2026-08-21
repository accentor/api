require 'test_helper'

class CoverFilenamePolicyTest < ActiveSupport::TestCase
  setup do
    @cover_filename = create(:cover_filename)
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user and regular user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, CoverFilename)
    end

    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(@user, CoverFilename)
    end
  end

  test 'scope should not be created for signed-out user and regular user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, CoverFilename)
    end

    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(@user, CoverFilename)
    end
  end

  test 'moderator+ should see cover filenames' do
    assert_scope_includes @moderator, @cover_filename
    assert_scope_includes @admin, @cover_filename
  end

  test 'moderator+ should be allowed to access index' do
    assert_permitted @moderator, CoverFilename, :index
    assert_permitted @admin, CoverFilename, :index
  end

  test 'moderator+ should be allowed to see a cover filename' do
    assert_permitted @moderator, @cover_filename, :show
    assert_permitted @admin, @cover_filename, :show
  end

  test 'moderator+ should be allowed to create a cover filename' do
    assert_permitted @moderator, CoverFilename, :create
    assert_permitted @admin, CoverFilename, :create
  end

  test 'moderator+ should be allowed to destroy a cover filename' do
    assert_permitted @moderator, @cover_filename, :destroy
    assert_permitted @admin, @cover_filename, :destroy
  end

  test 'moderator+ should be allowed to set all attributes for a cover filename' do
    assert_attributes_permitted @moderator, @cover_filename, %i[filename]
    assert_attributes_permitted @admin, @cover_filename, %i[filename]
  end
end
