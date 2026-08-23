require 'test_helper'

class ArtistPolicyTest < ActiveSupport::TestCase
  setup do
    @artist = create(:artist)
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, Artist)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, Artist)
    end
  end

  test 'all users should see artists' do
    assert_scope_includes @user, @artist
    assert_scope_includes @moderator, @artist
    assert_scope_includes @admin, @artist
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, Artist, :index
    assert_permitted @moderator, Artist, :index
    assert_permitted @admin, Artist, :index
  end

  test 'all users should be allowed to see an artist' do
    assert_permitted @user, @artist, :show
    assert_permitted @moderator, @artist, :show
    assert_permitted @admin, @artist, :show
  end

  test 'only moderator+ should be allowed to create an artist' do
    assert_not_permitted @user, Artist, :create
    assert_permitted @moderator, Artist, :create
    assert_permitted @admin, Artist, :create
  end

  test 'all users should be allowed to update an artist' do
    assert_permitted @user, @artist, :update
    assert_permitted @moderator, @artist, :update
    assert_permitted @admin, @artist, :update
  end

  test 'only moderator+ should be allowed to destroy an artist' do
    assert_not_permitted @user, @artist, :destroy
    assert_permitted @moderator, @artist, :destroy
    assert_permitted @admin, @artist, :destroy
  end

  test 'only moderator+ should be allowed to destroy empty artists' do
    assert_not_permitted @user, Artist, :destroy_empty
    assert_permitted @moderator, Artist, :destroy_empty
    assert_permitted @admin, Artist, :destroy_empty
  end

  test 'only moderator+ should be allowed to merge an artist' do
    assert_not_permitted @user, @artist, :merge
    assert_permitted @moderator, @artist, :merge
    assert_permitted @admin, @artist, :merge
  end

  test 'regular user should only be allowed to change the review_comment of an artist' do
    assert_attributes_permitted @user, @artist, %i[review_comment]
  end

  test 'moderator+ should be allowed to change all attributes of an artist' do
    assert_attributes_permitted @moderator, @artist, [:name, :review_comment, { image: %i[data filename mimetype] }]
    assert_attributes_permitted @admin, @artist, [:name, :review_comment, { image: %i[data filename mimetype] }]
  end
end
