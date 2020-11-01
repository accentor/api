# == Schema Information
#
# Table name: plays
#
#  id        :bigint           not null, primary key
#  played_at :datetime         not null
#  track_id  :bigint           not null
#  user_id   :bigint           not null
#
require 'test_helper'

class PlayTest < ActiveSupport::TestCase
  test 'should pass if played_at is in past' do
    play = build(:play, played_at: DateTime.current.ago(1))
    assert play.valid?
  end

  test 'should pass if playad_at is now' do
    play = build(:play, played_at: DateTime.current)
    assert play.valid?
  end

  test 'should reject if played_at is in future' do
    play = build(:play, played_at: DateTime.current.end_of_minute)
    assert_not play.valid?
    assert_not_empty play.errors[:played_at]
  end
end
