# == Schema Information
#
# Table name: track_artists
#
#  id              :bigint           not null, primary key
#  hidden          :boolean          default(FALSE), not null
#  name            :string           not null
#  normalized_name :string           not null
#  order           :integer          not null
#  role            :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  artist_id       :bigint           not null
#  track_id        :bigint           not null
#
# Indexes
#
#  index_track_artists_on_artist_id                                 (artist_id)
#  index_track_artists_on_normalized_name                           (normalized_name)
#  index_track_artists_on_track_id                                  (track_id)
#  index_track_artists_on_track_id_and_artist_id_and_name_and_role  (track_id,artist_id,name,role) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => artists.id)
#  fk_rails_...  (track_id => tracks.id)
#

class TrackArtist < ApplicationRecord
  include HasNormalized

  enum :role, { main: 0, performer: 1, composer: 2, conductor: 3, remixer: 4, producer: 5, arranger: 6 }

  belongs_to :track, touch: true
  belongs_to :artist

  validates :role, presence: true
  validates :name, presence: true, uniqueness: { scope: %i[track artist role] }
  validates :order, presence: true

  normalized_col_generator :name
end
