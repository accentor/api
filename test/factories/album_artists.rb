# == Schema Information
#
# Table name: album_artists
#
#  id        :bigint(8)        not null, primary key
#  album_id  :bigint(8)        not null
#  artist_id :bigint(8)        not null
#  name      :string           not null
#  order     :integer          not null
#  join      :string
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
