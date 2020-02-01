# == Schema Information
#
# Table name: albums
#
#  id                  :bigint           not null, primary key
#  title               :string           not null
#  image_id            :bigint
#  release             :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  review_comment      :string
#  edition             :date
#  edition_description :string
#  normalized_title    :string           not null
#

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
    test 'should automatically generate normalized_title' do
        album = build(:album, title: 'ïóùåAÁ')
        album.save
        assert_not album.normalized_title.nil?
        assert_equal "iouaaa", album.normalized_title
    end
end
