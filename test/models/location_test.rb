# == Schema Information
#
# Table name: locations
#
#  id   :bigint           not null, primary key
#  path :string           not null
#

require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  setup do
    create(:location, path: '/var/parent')
  end

  test 'location cant be subdirectory of other location' do
    child = build(:location, path: '/var/parent/music')
    assert_not child.valid?
    assert_not_empty child.errors[:path]
  end

  test 'location cant be parent of other location' do
    parent = build(:location, path: '/var')
    assert_not parent.valid?
    assert_not_empty parent.errors[:path]
  end

  test 'should be able to add similar siblings' do
    sibling = build(:location, path: '/var/parent2')
    assert_predicate sibling, :valid?
  end

  test 'location should not match parent/subdir if different case' do
    parent = build(:location, path: '/Var')
    assert_predicate parent, :valid?
    child = build(:location, path: '/Var/parent/Music')
    assert_predicate child, :valid?
  end

  test 'should create a rescan runner' do
    assert_difference('RescanRunner.count', 1) do
      create(:location)
    end
  end
end
