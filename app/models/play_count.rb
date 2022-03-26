# == Schema Information
#
# Table name: play_counts
#
#  play_count :bigint
#  track_id   :bigint
#  user_id    :bigint
#
class PlayCount < ApplicationRecord
  belongs_to :track
  belongs_to :user

  def readonly?
    true
  end
end
