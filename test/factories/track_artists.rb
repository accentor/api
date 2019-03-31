# == Schema Information
#
# Table name: track_artists
#
#  id        :bigint(8)        not null, primary key
#  track_id  :bigint(8)        not null
#  artist_id :bigint(8)        not null
#  name      :string           not null
#  role      :integer          not null
#

FactoryBot.define do
  factory :track_artist do
    track {nil}
    artist {nil}
    name {"MyString"}
    role {"MyString"}
  end
end
