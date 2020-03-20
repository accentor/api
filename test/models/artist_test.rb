# == Schema Information
#
# Table name: artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#  review_comment  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  image_id        :bigint
#

require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
    test 'should automatically generate normalized_name' do
        artist = build(:artist, name: 'ïóùåAÁ')
        artist.save
        assert_not artist.normalized_name.nil?
        assert_equal "iouaaa", artist.normalized_name
    end
end
