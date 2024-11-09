# == Schema Information
#
# Table name: plays
#
#  id        :bigint           not null, primary key
#  played_at :datetime         not null
#  track_id  :bigint           not null
#  user_id   :bigint           not null
#
# Indexes
#
#  index_plays_on_track_id              (track_id)
#  index_plays_on_user_id               (user_id)
#  index_plays_on_user_id_and_track_id  (user_id,track_id)
#
# Foreign Keys
#
#  fk_rails_...  (track_id => tracks.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :play do
    track
    user
    played_at { DateTime.current }
  end
end
