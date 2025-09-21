require 'test_helper'

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in_as(@user)
    @playlist = create(:playlist, access: :shared)
  end

  test 'should get index' do
    query = Playlist.where.not(access: :secret).or(Playlist.where(access: :secret, user_id: @user.id)).with_item_ids.order(id: :asc)
    expected_etag = construct_etag(query)

    get playlists_url

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should get index and return not modified if etag matches' do
    query = Playlist.where.not(access: :secret).or(Playlist.where(access: :secret, user_id: @user.id)).with_item_ids.order(id: :asc)
    expected_etag = construct_etag(query)

    get playlists_url, headers: { 'If-None-Match': expected_etag }

    assert_response :not_modified
    assert_empty response.parsed_body
  end

  test 'should get index and include page in etag' do
    query = Playlist.where.not(access: :secret).or(Playlist.where(access: :secret, user_id: @user.id)).with_item_ids.order(id: :asc)
    expected_etag = construct_etag(query, page: 5, per_page: 501)

    get playlists_url(page: 5, per_page: 501)

    assert_response :success
    assert_equal expected_etag, headers['etag']
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

    assert_response :unprocessable_content
  end

  test 'should create personal playlist for current user if specified' do
    assert_difference('Playlist.count', 1) do
      post playlists_url, params: { playlist: { name: 'My favorite songs', playlist_type: :track, access: :personal } }
    end

    assert_response :created
    assert_predicate Playlist.last, :personal?
    assert_equal @user.id, Playlist.last.user_id
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
    patch playlist_url(@playlist), params: { playlist: { name: 'My playlist', access: :personal } }

    assert_response :success
  end

  test 'should not update playlist with empty name' do
    patch playlist_url(@playlist), params: { playlist: { name: '' } }

    assert_response :unprocessable_content
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
    @playlist.update(access: :personal)

    patch playlist_url(@playlist), params: { playlist: { name: 'My playlist' } }

    assert_response :forbidden
  end

  test 'should not update secret playlist for different user' do
    @playlist.update(access: :secret)

    patch playlist_url(@playlist), params: { playlist: { name: 'My playlist' } }

    assert_response :forbidden
  end

  test 'should destroy shared playlist for user' do
    assert_difference('Playlist.count', -1) do
      delete playlist_url(@playlist)
    end

    assert_response :success
  end

  test 'should not destroy personal playlist for different user' do
    @playlist.update(access: :personal)

    assert_no_difference('Playlist.count') do
      delete playlist_url(@playlist)
    end

    assert_response :forbidden
  end

  test 'should not destroy secret playlist for different user' do
    @playlist.update(access: :secret)

    assert_no_difference('Playlist.count') do
      delete playlist_url(@playlist)
    end

    assert_response :forbidden
  end

  test 'should not add item if no user' do
    @playlist.update(playlist_type: :track)
    track = create(:track)
    sign_out

    assert_no_difference 'PlaylistItem.count' do
      post add_item_playlist_url(@playlist), params: { playlist: { item_id: track.id, item_type: 'Track' } }
    end

    assert_response :unauthorized
  end

  test 'should add item in shared playlist' do
    @playlist.update(playlist_type: :track)
    track = create(:track)

    assert_difference('PlaylistItem.count', 1) do
      post add_item_playlist_url(@playlist), params: { playlist: { item_id: track.id, item_type: 'Track' } }
    end

    assert_response :no_content
    assert_equal 1, PlaylistItem.last.order
  end

  test 'should add item in personal playlist that belongs to user' do
    playlist = create(:playlist, access: :personal, playlist_type: :track, user: @user)
    track = create(:track)

    assert_difference('PlaylistItem.count', 1) do
      post add_item_playlist_url(playlist), params: { playlist: { item_id: track.id, item_type: 'Track' } }
    end

    assert_response :no_content
    assert_equal 1, PlaylistItem.last.order
  end

  test 'should not add item in personal playlist that does not belongs to user' do
    playlist = create(:playlist, access: :personal, playlist_type: :track)
    track = create(:track)

    assert_no_difference 'PlaylistItem.count' do
      post add_item_playlist_url(playlist), params: { playlist: { item_id: track.id, item_type: 'Track' } }
    end

    assert_response :forbidden
  end
end
