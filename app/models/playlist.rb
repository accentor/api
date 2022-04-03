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
class Playlist < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'PlaylistItem', dependent: :destroy

  enum access: { shared: 0, personal: 1, secret: 2 }
  enum playlist_type: { album: 1, artist: 2, track: 3 }

  validates :name, presence: true

  before_save :normalize_item_order

  def item_ids
    items.loaded? ? items.sort_by(&:order).collect(&:item_id) : items.order(:order).pluck(:item_id)
  end

  def item_ids=(ids)
    item_type = playlist_type.capitalize
    self.items = ids.map.with_index(1) { |id, i| PlaylistItem.new(item_id: id, item_type:, order: i) }
  end

  private

  def normalize_item_order
    items.sort { |i1, i2| i1.order <=> i2.order }.map.with_index(1) do |item, index|
      item.order = index
      item.save unless item.new_record?
    end
  end
end
