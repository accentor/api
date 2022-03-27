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
class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :user_id, :playlist_type, :created_at, :updated_at, :item_ids

  def item_ids
    object.items.order(:order).pluck(:item_id)
  end
end
