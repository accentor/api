# == Schema Information
#
# Table name: labels
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#

require 'test_helper'

class LabelTest < ActiveSupport::TestCase
    test 'should automatically generate normalized_name' do
        label = build(:label, name: 'ïóùåAÁ')
        label.save
        assert_not label.normalized_name.nil?
        assert_equal "iouaaa", label.normalized_name
    end
end
