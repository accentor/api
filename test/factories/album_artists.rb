# == Schema Information
#
# Table name: album_artists
#
#  id              :bigint           not null, primary key
#  album_id        :bigint           not null
#  artist_id       :bigint           not null
#  name            :string           not null
#  order           :integer          not null
#  separator       :string
#  normalized_name :string           not null
#

FactoryBot.define do
  factory :album_artist do
    album
    artist
    separator {" / "}
    order {1}
    name {Faker::Music.band}
  end
end
