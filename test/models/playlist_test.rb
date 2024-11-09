# == Schema Information
#
# Table name: playlists
#
#  id            :bigint           not null, primary key
#  access        :integer          default("shared")
#  description   :string
#  name          :string           not null
#  playlist_type :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_playlists_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  test 'should have name' do
    list = build(:playlist, name: '')

    assert_not_predicate list, :valid?
    assert_not_empty list.errors[:name]
  end

  test 'should normalize order of items' do
    i1 = build(:playlist_item, order: 5, item: create(:track))
    i2 = build(:playlist_item, order: 2, item: create(:track))
    list = build(:playlist, playlist_type: :track, items: [i1, i2])
    list.save

    assert_equal 2, i1.order
    assert_equal 1, i2.order
  end

  test 'should leave order of track items alone if normalized' do
    i1 = build(:playlist_item, order: 1, item: create(:track))
    i2 = build(:playlist_item, order: 2, item: create(:track))
    list = build(:playlist, playlist_type: :track, items: [i1, i2])
    list.save

    assert_equal 1, i1.order
    assert_equal 2, i2.order
  end

  test 'should normalize order of items in order provided if equal' do
    i1 = build(:playlist_item, order: 0, item: create(:track))
    i2 = build(:playlist_item, order: 0, item: create(:track))
    list = build(:playlist, playlist_type: :track, items: [i1, i2])
    list.save

    assert_equal 1, i1.order
    assert_equal 2, i2.order
  end

  test 'should get item_ids' do
    i1 = build(:playlist_item, order: 2)
    i2 = build(:playlist_item, order: 1)
    list = build(:playlist, playlist_type: :track, items: [i1, i2])
    list.save

    assert_equal [i2.item_id, i1.item_id], list.item_ids
  end

  test 'should set item_ids' do
    t1 = create(:track)
    t2 = create(:track)
    list = build(:playlist, playlist_type: :track)
    list.item_ids = [t1.id, t2.id]

    assert_equal 2, list.items.length
    assert_equal t1, list.items.first.item
    assert_equal t2, list.items.second.item
  end

  test 'should not be valid if double item_id is present' do
    track = create(:track)
    list = build(:playlist, playlist_type: :track, item_ids: [track.id, track.id])

    assert_not list.valid?
    assert_not_empty list.errors['items']
  end

  test 'should return empty item_ids when using `with_item_ids` if there are no items' do
    create(:playlist, playlist_type: :track)

    assert_empty Playlist.with_item_ids.first.item_ids
  end
end
