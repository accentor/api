# == Schema Information
#
# Table name: plays
#
#  id        :bigint           not null, primary key
#  played_at :datetime         not null
#  track_id  :bigint           not null
#  user_id   :bigint           not null
#
class Play < ApplicationRecord
  belongs_to :track
  belongs_to :user

  validates :played_at, presence: true
  validate :play_cannot_be_in_future

  def play_cannot_be_in_future
    errors.add(:played_at, 'play-not-in-future') unless played_at <= DateTime.current
  end
end
