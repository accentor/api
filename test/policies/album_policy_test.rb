require 'test_helper'

class AlbumPolicyTest < ActiveSupport::TestCase
  setup do
    @album = create(:album)
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, Album)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, Album)
    end
  end

  test 'all users should see albums' do
    assert_scope_includes @user, @album
    assert_scope_includes @moderator, @album
    assert_scope_includes @admin, @album
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, Album, :index
    assert_permitted @moderator, Album, :index
    assert_permitted @admin, Album, :index
  end

  test 'all users should be allowed to see an album' do
    assert_permitted @user, @album, :show
    assert_permitted @moderator, @album, :show
    assert_permitted @admin, @album, :show
  end

  test 'only moderator+ should be allowed to create an album' do
    assert_not_permitted @user, Album, :create
    assert_permitted @moderator, Album, :create
    assert_permitted @admin, Album, :create
  end

  test 'all users should be allowed to update an album' do
    assert_permitted @user, @album, :update
    assert_permitted @moderator, @album, :update
    assert_permitted @admin, @album, :update
  end

  test 'only moderator+ should be allowed to destroy an album' do
    assert_not_permitted @user, @album, :destroy
    assert_permitted @moderator, @album, :destroy
    assert_permitted @admin, @album, :destroy
  end

  test 'only moderator+ should be allowed to destroy empty albums' do
    assert_not_permitted @user, Album, :destroy_empty
    assert_permitted @moderator, Album, :destroy_empty
    assert_permitted @admin, Album, :destroy_empty
  end

  test 'only moderator+ should be allowed to merge an album' do
    assert_not_permitted @user, @album, :merge
    assert_permitted @moderator, @album, :merge
    assert_permitted @admin, @album, :merge
  end

  test 'regular user should only be allowed to change the review_comment of an album' do
    assert_attributes_permitted @user, @album, %i[review_comment]
  end

  test 'moderator+ should be allowed to change all attributes of an album' do
    assert_attributes_permitted @moderator, @album, [:title, :release, :review_comment, :edition, :edition_description, { image: %i[data filename mimetype], album_artists: %i[artist_id name order separator], album_labels: %i[label_id catalogue_number] }]
    assert_attributes_permitted @admin, @album, [:title, :release, :review_comment, :edition, :edition_description, { image: %i[data filename mimetype], album_artists: %i[artist_id name order separator], album_labels: %i[label_id catalogue_number] }]
  end
end
