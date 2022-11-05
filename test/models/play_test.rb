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
  test 'should be able to filter by album' do
    @play = create(:play)

    assert_includes Play.by_album(@play.track.album_id), @play
    assert_empty Play.by_album(@play.track.album_id + 1)
  end
end
