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
end
