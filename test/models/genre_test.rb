# == Schema Information
#
# Table name: genres
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#

require 'test_helper'

class GenreTest < ActiveSupport::TestCase
    test 'should automatically generate normalized_name' do
        genre = build(:genre, name: 'ïóùåAÁ')
        genre.save
        assert_not genre.normalized_name.nil?
        assert_equal "iouaaa", genre.normalized_name
    end
end
