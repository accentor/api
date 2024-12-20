# == Schema Information
#
# Table name: playlist_items
#
#  id          :bigint           not null, primary key
#  item_type   :string           not null
#  order       :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  item_id     :integer          not null
#  playlist_id :bigint           not null
#
# Indexes
#
#  index_playlist_items_on_playlist_id              (playlist_id)
#  index_playlist_items_on_playlist_id_and_item_id  (playlist_id,item_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (playlist_id => playlists.id)
#
require 'test_helper'

class PlayListItemTest < ActiveSupport::TestCase
  test 'item should match playlist type' do
    playlist = create(:playlist, playlist_type: :album)
    item = build(:playlist_item, :for_album, playlist:)

    assert_predicate item, :valid?
    assert_empty item.errors[:item]
  end

  test 'item type cant be different from playlist type' do
    playlist = create(:playlist, playlist_type: :album)
    item = build(:playlist_item, :for_track, playlist:)

    assert_not_predicate item, :valid?
    assert_not_empty item.errors[:item]
  end

  test 'item should get order if not present' do
    playlist = create(:playlist, playlist_type: :album)
    item = build(:playlist_item, :for_track, playlist:, order: nil)

    item.validate

    assert_equal 1, item.order
  end
end
