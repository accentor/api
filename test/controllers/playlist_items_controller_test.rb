require "test_helper"

class PlaylistItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in_as(@user)
    @playlist = create(:playlist, access: :shared, playlist_type: :track)
    @track = create(:track)
  end

  test 'should not create playlist item if no user' do
    sign_out

    assert_no_difference 'PlaylistItem.count' do
      post playlist_items_url, params: { playlist_item: { playlist_id: @playlist.id, item_id: @track.id, item_type: 'Track' } }
    end

    assert_response :unauthorized
  end 
  
  test 'should create playlist item in shared playlist' do
    assert_difference('PlaylistItem.count', 1) do
      post playlist_items_url, params: { playlist_item: { playlist_id: @playlist.id, item_id: @track.id, item_type: 'Track' } }
    end

    assert_response :created
    assert_equal PlaylistItem.last.order, 1
  end 

  test 'should create playlist item in personal playlist that belongs to user' do
    playlist = create(:playlist, access: :personal, playlist_type: :track, user: @user)

    assert_difference('PlaylistItem.count', 1) do
      post playlist_items_url, params: { playlist_item: { playlist_id: playlist.id, item_id: @track.id, item_type: 'Track' } }
    end

    assert_response :created
    assert_equal PlaylistItem.last.order, 1
  end 

  test 'should not create playlist item in personal playlist that does not belongs to user' do
    playlist = create(:playlist, access: :personal, playlist_type: :track)

    assert_no_difference 'PlaylistItem.count' do
      post playlist_items_url, params: { playlist_item: { playlist_id: playlist.id, item_id: @track.id, item_type: 'Track' } }
    end

    assert_response :forbidden
  end 
end
