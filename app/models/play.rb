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

  scope :by_album, ->(album) { where(track_id: Track.by_album(album)) }
  scope :by_artist, ->(artist) { where(track_id: Track.by_artist(artist)) }
  scope :played_before, ->(date) { where(played_at: ...date) }
  scope :played_after, ->(date) { where(played_at: date...) }
end
