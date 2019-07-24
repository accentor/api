# == Schema Information
#
# Table name: album_artists
#
#  id        :bigint           not null, primary key
#  album_id  :bigint           not null
#  artist_id :bigint           not null
#  name      :string           not null
#  order     :integer          not null
#  separator :string
#

require 'test_helper'

class AlbumArtistTest < ActiveSupport::TestCase
end
