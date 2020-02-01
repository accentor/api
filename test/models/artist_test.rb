# == Schema Information
#
# Table name: artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  image_id        :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  review_comment  :string
#  normalized_name :string           not null
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
