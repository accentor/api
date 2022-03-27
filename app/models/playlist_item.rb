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
class PlaylistItem < ApplicationRecord
  belongs_to :playlist
  belongs_to :item, polymorphic: true

  validates :order, presence: true
  validate :item_type_should_match_playlist_type

  private

  def item_type_should_match_playlist_type
    errors.add(:item, 'item-type-different-from-playlist-type') unless item_type.downcase == playlist.playlist_type
  end
end
