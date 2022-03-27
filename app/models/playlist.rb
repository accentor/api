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
class Playlist < ApplicationRecord
  belongs_to :user, optional: true
  has_many :items, class_name: 'PlaylistItem', dependent: :destroy

  enum playlist_type: { album: 1, artist: 2, track: 3 }

  validates :name, presence: true

  before_save :normalize_item_order

  def shared?
    user_id.nil?
  end

  def personal?
    user_id.present?
  end

  private

  def normalize_item_order
    items.sort { |i1, i2| i1.order <=> i2.order }.map.with_index(1) do |item, index|
      item.order = index
      item.save unless item.new_record?
    end
  end
end
