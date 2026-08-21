require 'test_helper'

class GenrePolicyTest < ActiveSupport::TestCase
  setup do
    @genre = create(:genre)
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, Genre)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, Genre)
    end
  end

  test 'all users should see genres' do
    assert_scope_includes @user, @genre
    assert_scope_includes @moderator, @genre
    assert_scope_includes @admin, @genre
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, Genre, :index
    assert_permitted @moderator, Genre, :index
    assert_permitted @admin, Genre, :index
  end

  test 'all users should be allowed to see a genre' do
    assert_permitted @user, @genre, :show
    assert_permitted @moderator, @genre, :show
    assert_permitted @admin, @genre, :show
  end

  test 'only moderator+ should be allowed to create a genre' do
    assert_not_permitted @user, Genre, :create
    assert_permitted @moderator, Genre, :create
    assert_permitted @admin, Genre, :create
  end

  test 'only moderator+ should be allowed to update a genre' do
    assert_not_permitted @user, @genre, :update
    assert_permitted @moderator, @genre, :update
    assert_permitted @admin, @genre, :update
  end

  test 'only moderator+ should be allowed to destroy a genre' do
    assert_not_permitted @user, @genre, :destroy
    assert_permitted @moderator, @genre, :destroy
    assert_permitted @admin, @genre, :destroy
  end

  test 'only moderator+ should be allowed to destroy empty genres' do
    assert_not_permitted @user, Genre, :destroy_empty
    assert_permitted @moderator, Genre, :destroy_empty
    assert_permitted @admin, Genre, :destroy_empty
  end

  test 'only moderator+ should be allowed to merge a genre' do
    assert_not_permitted @user, @genre, :merge
    assert_permitted @moderator, @genre, :merge
    assert_permitted @admin, @genre, :merge
  end

  test 'moderator+ should be allowed to change all attributes of a genre' do
    assert_no_permitted_attributes @user, @genre
    assert_attributes_permitted @moderator, @genre, %i[name]
    assert_attributes_permitted @admin, @genre, %i[name]
  end
end
