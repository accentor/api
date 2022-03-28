require 'test_helper'

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @playlist = create(:playlist)
    sign_in_as(create(:user))
  end

  test 'should get index' do
    get playlists_url
    assert_response :success
  end

  test 'should create playlist for user' do
    assert_difference('Playlist.count', 1) do
      post playlists_url, params: { playlist: { name: 'My favorite songs', playlist_type: :track } }
    end

    assert_response :created
    assert_predicate Playlist.last, :shared?
  end

  test 'should create playlist item for each included item_id' do
    t1 = create(:track)
    t2 = create(:track)

    assert_difference('PlaylistItem.count', 2) do
      assert_difference('Playlist.count', 1) do
        post playlists_url, params: { playlist: { name: 'My favorite songs', playlist_type: :track, item_ids: [t1.id, t2.id] } }
      end
    end

    assert_response :created
    assert_equal t1, Playlist.last.items.order(:order).first.item
  end

  test 'should not create playlist with empty name' do
    assert_difference('Playlist.count', 0) do
      post playlists_url, params: { playlist: { name: '', playlist_type: :track } }
    end

    assert_response :unprocessable_entity
  end

  test 'should create personal playlist for current user if specified' do
    assert_difference('Playlist.count', 1) do
      post playlists_url, params: { playlist: { name: 'My favorite songs', playlist_type: :track, personal: true } }
    end

    assert_response :created
    assert_predicate Playlist.last, :personal?
    assert_equal User.first.id, Playlist.last.user_id
  end

  test 'should show playlist' do
    get playlist_url(@playlist)
    assert_response :success
  end

  test 'should update playlist for user' do
    patch playlist_url(@playlist), params: { playlist: { name: 'My playlist' } }
    assert_response :success
  end

  test 'should update personal for user' do
    patch playlist_url(@playlist), params: { playlist: { name: 'My playlist', personal: false } }
    assert_response :success
  end

  test 'should not update playlist with empty name' do
    patch playlist_url(@playlist), params: { playlist: { name: '' } }
    assert_response :unprocessable_entity
  end

  test 'should create playlist items during update' do
    @playlist.update(playlist_type: :track)
    t1 = create(:track)
    t2 = create(:track)

    assert_difference('PlaylistItem.count', 2) do
      patch playlist_url(@playlist), params: { playlist: { name: 'My list', item_ids: [t1.id, t2.id] } }
    end

    assert_response :success
    assert_equal t1, Playlist.last.items.order(:order).first.item
  end

  test 'should not update personal playlist for different user' do
    @playlist.update(user: create(:user))

    patch playlist_url(@playlist), params: { playlist: { name: 'My playlist' } }
    assert_response :forbidden
  end

  test 'should destroy playlist for user' do
    assert_difference('Playlist.count', -1) do
      delete playlist_url(@playlist)
    end

    assert_response :success
  end

  test 'should not destroy personal playlist for different user' do
    @playlist.update(user: create(:user))

    assert_no_difference('Playlist.count') do
      delete playlist_url(@playlist)
    end

    assert_response :forbidden
  end
end
