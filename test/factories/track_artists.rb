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
#  artist_id       :bigint           not null
#  track_id        :bigint           not null
#

FactoryBot.define do
  factory :track_artist do
    track
    artist
    name { Faker::Lorem.word }
    role { TrackArtist.roles.keys.sample }
    order { 1 }
  end
end
