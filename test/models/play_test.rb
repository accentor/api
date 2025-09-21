# == Schema Information
#
# Table name: plays
#
#  id         :bigint           not null, primary key
#  played_at  :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  track_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_plays_on_track_id                (track_id)
#  index_plays_on_user_id                 (user_id)
#  index_plays_on_user_id_and_track_id    (user_id,track_id)
#  index_plays_on_user_id_and_updated_at  (user_id,updated_at)
#
# Foreign Keys
#
#  fk_rails_...  (track_id => tracks.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class PlayTest < ActiveSupport::TestCase
  test 'should be able to filter by album' do
    @play = create(:play)

    assert_includes Play.by_album(@play.track.album_id), @play
    assert_empty Play.by_album(@play.track.album_id + 1)
  end
end
