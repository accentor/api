# == Schema Information
#
# Table name: play_counts
#
#  play_count :bigint
#  track_id   :bigint
#  user_id    :bigint
#
require 'test_helper'

class PlayCountTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @track = create(:track)
    create(:play, user: @user, track: @track)
  end

  test 'should be readonly' do
    assert_raise ActiveRecord::ReadOnlyRecord do
      PlayCount.first.update(play_count: 20)
    end
  end

  test 'should calc play count per user and track' do
    assert_equal 1, PlayCount.where(user: @user, track: @track).length
    assert_equal 1, PlayCount.find_by(user: @user, track: @track).play_count
  end

  test 'should ignore plays from other users' do
    create(:play, track: @track)
    assert_equal 1, PlayCount.where(user: @user, track: @track).length
    assert_equal 1, PlayCount.find_by(user: @user, track: @track).play_count
  end

  test 'should ignore plays of other tracks' do
    create(:play, user: @user)
    assert_equal 1, PlayCount.where(user: @user, track: @track).length
    assert_equal 1, PlayCount.find_by(user: @user, track: @track).play_count
  end

  test 'should create a count per track/user, even if there are no plays' do
    user = create(:user)
    assert_equal 1, PlayCount.where(user:, track: @track).length
    assert_equal 0, PlayCount.find_by(user:, track: @track).play_count
  end
end
