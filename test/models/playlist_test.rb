# == Schema Information
#
# Table name: playlists
#
#  id            :bigint           not null, primary key
#  description   :string
#  name          :string           not null
#  playlist_type :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  test 'should have name' do
    list = build(:playlist, name: '')
    assert_not_predicate list, valid?
    assert_not_empty list.errors[:name]
  end

  test 'should normalize order of items' do
    i1 = build(:playlist_item, order: 5)
    i2 = build(:playlist_item, order: 2)
    list = build(:playlist, playlist_type: :track, items: [i1, i2])
    list.save
    assert_equal 2, i1.order
    assert_equal 1, i2.order
  end

  test 'should leave order of track items alone if normalized' do
    i1 = build(:playlist_item, order: 1)
    i2 = build(:playlist_item, order: 2)
    list = build(:playlist, playlist_type: :track, items: [i1, i2])
    list.save
    assert_equal 1, i1.order
    assert_equal 2, i2.order
  end

  test 'should normalize order of items in order provided if equal' do
    i1 = build(:playlist_item, order: 0)
    i2 = build(:playlist_item, order: 0)
    list = build(:playlist, playlist_type: :track, items: [i1, i2])
    list.save
    assert_equal 1, i1.order
    assert_equal 2, i2.order
  end
end
