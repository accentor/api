require 'test_helper'

class PlaylistPolicyTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)

    @user_secret_playlist = create(:playlist, access: :secret, user: @user)
    @moderator_secret_playlist = create(:playlist, access: :secret, user: @moderator)
    @admin_secret_playlist = create(:playlist, access: :secret, user: @admin)

    @user_personal_playlist = create(:playlist, access: :personal, user: @user)
    @moderator_personal_playlist = create(:playlist, access: :personal, user: @moderator)
    @admin_personal_playlist = create(:playlist, access: :personal, user: @admin)

    @user_shared_playlist = create(:playlist, access: :shared, user: @user)
    @moderator_shared_playlist = create(:playlist, access: :shared, user: @moderator)
    @admin_shared_playlist = create(:playlist, access: :shared, user: @admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, Playlist)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, Playlist)
    end
  end

  test 'users should see their own and public playlists' do
    assert_scope_includes @user, @user_secret_playlist, @user_personal_playlist, @user_shared_playlist, @moderator_personal_playlist, @moderator_shared_playlist, @admin_personal_playlist, @admin_shared_playlist
    assert_scope_not_includes @user, @moderator_secret_playlist, @admin_secret_playlist

    assert_scope_includes @moderator, @user_personal_playlist, @user_shared_playlist, @moderator_secret_playlist, @moderator_personal_playlist, @moderator_shared_playlist, @admin_personal_playlist, @admin_shared_playlist
    assert_scope_not_includes @moderator, @user_secret_playlist, @admin_secret_playlist

    assert_scope_includes @admin, @user_personal_playlist, @user_shared_playlist, @moderator_personal_playlist, @moderator_shared_playlist, @admin_secret_playlist, @admin_personal_playlist, @admin_shared_playlist
    assert_scope_not_includes @admin, @user_secret_playlist, @moderator_secret_playlist
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, Playlist, :index
    assert_permitted @moderator, Playlist, :index
    assert_permitted @admin, Playlist, :index
  end

  test 'users should see their own secret playlists but not from other users' do
    assert_permitted @user, @user_secret_playlist, :show
    assert_not_permitted @user, @moderator_secret_playlist, :show
    assert_not_permitted @user, @admin_secret_playlist, :show

    assert_not_permitted @moderator, @user_secret_playlist, :show
    assert_permitted @moderator, @moderator_secret_playlist, :show
    assert_not_permitted @moderator, @admin_secret_playlist, :show

    assert_not_permitted @admin, @user_secret_playlist, :show
    assert_not_permitted @admin, @moderator_secret_playlist, :show
    assert_permitted @admin, @admin_secret_playlist, :show
  end

  test 'users should see all personal playlists' do
    assert_permitted @user, @user_personal_playlist, :show
    assert_permitted @user, @moderator_personal_playlist, :show
    assert_permitted @user, @admin_personal_playlist, :show

    assert_permitted @moderator, @user_personal_playlist, :show
    assert_permitted @moderator, @moderator_personal_playlist, :show
    assert_permitted @moderator, @admin_personal_playlist, :show

    assert_permitted @admin, @user_personal_playlist, :show
    assert_permitted @admin, @moderator_personal_playlist, :show
    assert_permitted @admin, @admin_personal_playlist, :show
  end

  test 'users should see all shared playlists' do
    assert_permitted @user, @user_shared_playlist, :show
    assert_permitted @user, @moderator_shared_playlist, :show
    assert_permitted @user, @admin_shared_playlist, :show

    assert_permitted @moderator, @user_shared_playlist, :show
    assert_permitted @moderator, @moderator_shared_playlist, :show
    assert_permitted @moderator, @admin_shared_playlist, :show

    assert_permitted @admin, @user_shared_playlist, :show
    assert_permitted @admin, @moderator_shared_playlist, :show
    assert_permitted @admin, @admin_shared_playlist, :show
  end

  test 'all users should be allowed to create a playlist' do
    assert_permitted @user, Playlist, :create
    assert_permitted @moderator, Playlist, :create
    assert_permitted @admin, Playlist, :create
  end

  test 'users should update their own secret playlists but not from other users' do
    assert_permitted @user, @user_secret_playlist, :update
    assert_not_permitted @user, @moderator_secret_playlist, :update
    assert_not_permitted @user, @admin_secret_playlist, :update

    assert_not_permitted @moderator, @user_secret_playlist, :update
    assert_permitted @moderator, @moderator_secret_playlist, :update
    assert_not_permitted @moderator, @admin_secret_playlist, :update

    assert_not_permitted @admin, @user_secret_playlist, :update
    assert_not_permitted @admin, @moderator_secret_playlist, :update
    assert_permitted @admin, @admin_secret_playlist, :update
  end

  test 'users should update their own personal playlists but not from other users' do
    assert_permitted @user, @user_personal_playlist, :update
    assert_not_permitted @user, @moderator_personal_playlist, :update
    assert_not_permitted @user, @admin_personal_playlist, :update

    assert_not_permitted @moderator, @user_personal_playlist, :update
    assert_permitted @moderator, @moderator_personal_playlist, :update
    assert_not_permitted @moderator, @admin_personal_playlist, :update

    assert_not_permitted @admin, @user_personal_playlist, :update
    assert_not_permitted @admin, @moderator_personal_playlist, :update
    assert_permitted @admin, @admin_personal_playlist, :update
  end

  test 'users should update all shared playlists' do
    assert_permitted @user, @user_shared_playlist, :update
    assert_permitted @user, @moderator_shared_playlist, :update
    assert_permitted @user, @admin_shared_playlist, :update

    assert_permitted @moderator, @user_shared_playlist, :update
    assert_permitted @moderator, @moderator_shared_playlist, :update
    assert_permitted @moderator, @admin_shared_playlist, :update

    assert_permitted @admin, @user_shared_playlist, :update
    assert_permitted @admin, @moderator_shared_playlist, :update
    assert_permitted @admin, @admin_shared_playlist, :update
  end

  test 'users should destroy their own secret playlists but not from other users' do
    assert_permitted @user, @user_secret_playlist, :destroy
    assert_not_permitted @user, @moderator_secret_playlist, :destroy
    assert_not_permitted @user, @admin_secret_playlist, :destroy

    assert_not_permitted @moderator, @user_secret_playlist, :destroy
    assert_permitted @moderator, @moderator_secret_playlist, :destroy
    assert_not_permitted @moderator, @admin_secret_playlist, :destroy

    assert_not_permitted @admin, @user_secret_playlist, :destroy
    assert_not_permitted @admin, @moderator_secret_playlist, :destroy
    assert_permitted @admin, @admin_secret_playlist, :destroy
  end

  test 'users should destroy their own personal playlists but not from other users' do
    assert_permitted @user, @user_personal_playlist, :destroy
    assert_not_permitted @user, @moderator_personal_playlist, :destroy
    assert_not_permitted @user, @admin_personal_playlist, :destroy

    assert_not_permitted @moderator, @user_personal_playlist, :destroy
    assert_permitted @moderator, @moderator_personal_playlist, :destroy
    assert_not_permitted @moderator, @admin_personal_playlist, :destroy

    assert_not_permitted @admin, @user_personal_playlist, :destroy
    assert_not_permitted @admin, @moderator_personal_playlist, :destroy
    assert_permitted @admin, @admin_personal_playlist, :destroy
  end

  test 'users should destroy all shared playlists' do
    assert_permitted @user, @user_shared_playlist, :destroy
    assert_permitted @user, @moderator_shared_playlist, :destroy
    assert_permitted @user, @admin_shared_playlist, :destroy

    assert_permitted @moderator, @user_shared_playlist, :destroy
    assert_permitted @moderator, @moderator_shared_playlist, :destroy
    assert_permitted @moderator, @admin_shared_playlist, :destroy

    assert_permitted @admin, @user_shared_playlist, :destroy
    assert_permitted @admin, @moderator_shared_playlist, :destroy
    assert_permitted @admin, @admin_shared_playlist, :destroy
  end

  test 'users should add an item to their own secret playlists but not from other users' do
    assert_permitted @user, @user_secret_playlist, :add_item
    assert_not_permitted @user, @moderator_secret_playlist, :add_item
    assert_not_permitted @user, @admin_secret_playlist, :add_item

    assert_not_permitted @moderator, @user_secret_playlist, :add_item
    assert_permitted @moderator, @moderator_secret_playlist, :add_item
    assert_not_permitted @moderator, @admin_secret_playlist, :add_item

    assert_not_permitted @admin, @user_secret_playlist, :add_item
    assert_not_permitted @admin, @moderator_secret_playlist, :add_item
    assert_permitted @admin, @admin_secret_playlist, :add_item
  end

  test 'users should add an item to their own personal playlists but not from other users' do
    assert_permitted @user, @user_personal_playlist, :add_item
    assert_not_permitted @user, @moderator_personal_playlist, :add_item
    assert_not_permitted @user, @admin_personal_playlist, :add_item

    assert_not_permitted @moderator, @user_personal_playlist, :add_item
    assert_permitted @moderator, @moderator_personal_playlist, :add_item
    assert_not_permitted @moderator, @admin_personal_playlist, :add_item

    assert_not_permitted @admin, @user_personal_playlist, :add_item
    assert_not_permitted @admin, @moderator_personal_playlist, :add_item
    assert_permitted @admin, @admin_personal_playlist, :add_item
  end

  test 'users should add an item to all shared playlists' do
    assert_permitted @user, @user_shared_playlist, :add_item
    assert_permitted @user, @moderator_shared_playlist, :add_item
    assert_permitted @user, @admin_shared_playlist, :add_item

    assert_permitted @moderator, @user_shared_playlist, :add_item
    assert_permitted @moderator, @moderator_shared_playlist, :add_item
    assert_permitted @moderator, @admin_shared_playlist, :add_item

    assert_permitted @admin, @user_shared_playlist, :add_item
    assert_permitted @admin, @moderator_shared_playlist, :add_item
    assert_permitted @admin, @admin_shared_playlist, :add_item
  end

  test 'all users should be allowed to set all attributes for a playlist' do
    assert_attributes_permitted @user, Playlist, [:name, :description, :playlist_type, { item_ids: [] }, :access]
    assert_attributes_permitted @moderator, Playlist, [:name, :description, :playlist_type, { item_ids: [] }, :access]
    assert_attributes_permitted @admin, Playlist, [:name, :description, :playlist_type, { item_ids: [] }, :access]
  end

  test 'all users should be allowed to set item attributes when adding to a playlist' do
    assert_attributes_permitted @user, @user_secret_playlist, %i[item_id item_type], :add_item
    assert_attributes_permitted @moderator, @moderator_secret_playlist, %i[item_id item_type], :add_item
    assert_attributes_permitted @admin, @admin_secret_playlist, %i[item_id item_type], :add_item
  end
end
