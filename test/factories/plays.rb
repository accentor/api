# == Schema Information
#
# Table name: plays
#
#  id        :bigint           not null, primary key
#  played_at :datetime         not null
#  track_id  :bigint           not null
#  user_id   :bigint           not null
#
FactoryBot.define do
  factory :play do
    track
    user
    played_at { DateTime.current }
  end
end
