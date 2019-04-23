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

require 'test_helper'

class AlbumArtistTest < ActiveSupport::TestCase
end
