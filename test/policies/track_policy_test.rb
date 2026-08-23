require 'test_helper'

class TrackPolicyTest < ActiveSupport::TestCase
  setup do
    @track = create(:track)
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, Track)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, Track)
    end
  end

  test 'all users should see tracks' do
    assert_scope_includes @user, @track
    assert_scope_includes @moderator, @track
    assert_scope_includes @admin, @track
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, Track, :index
    assert_permitted @moderator, Track, :index
    assert_permitted @admin, Track, :index
  end

  test 'all users should be allowed to see a track' do
    assert_permitted @user, @track, :show
    assert_permitted @moderator, @track, :show
    assert_permitted @admin, @track, :show
  end

  test 'only moderator+ should be allowed to create a track' do
    assert_not_permitted @user, Track, :create
    assert_permitted @moderator, Track, :create
    assert_permitted @admin, Track, :create
  end

  test 'all users should be allowed to update a track' do
    assert_permitted @user, @track, :update
    assert_permitted @moderator, @track, :update
    assert_permitted @admin, @track, :update
  end

  test 'only moderator+ should be allowed to destroy a track' do
    assert_not_permitted @user, @track, :destroy
    assert_permitted @moderator, @track, :destroy
    assert_permitted @admin, @track, :destroy
  end

  test 'only moderator+ should be allowed to destroy empty tracks' do
    assert_not_permitted @user, Track, :destroy_empty
    assert_permitted @moderator, Track, :destroy_empty
    assert_permitted @admin, Track, :destroy_empty
  end

  test 'all users should be allowed to audio a track' do
    assert_permitted @user, @track, :audio
    assert_permitted @moderator, @track, :audio
    assert_permitted @admin, @track, :audio
  end

  test 'all users should be allowed to download a track' do
    assert_permitted @user, @track, :download
    assert_permitted @moderator, @track, :download
    assert_permitted @admin, @track, :download
  end

  test 'only moderator+ should be allowed to merge a track' do
    assert_not_permitted @user, @track, :merge
    assert_permitted @moderator, @track, :merge
    assert_permitted @admin, @track, :merge
  end

  test 'regular user should only be allowed to change the review_comment of a track' do
    assert_attributes_permitted @user, @track, %i[review_comment]
  end

  test 'moderator+ should be allowed to change all attributes of a track' do
    assert_attributes_permitted @moderator, @track, [:title, :number, :album_id, :review_comment, { genre_ids: [], track_artists: %i[artist_id name role order hidden] }]
    assert_attributes_permitted @admin, @track, [:title, :number, :album_id, :review_comment, { genre_ids: [], track_artists: %i[artist_id name role order hidden] }]
  end
end
