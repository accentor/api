class PlaylistItemPolicy < ApplicationPolicy
  def create?
    user.present? && (record.playlist&.shared? || record.playlist&.user_id == user.id)
  end

  def permitted_attributes
    %i[playlist_id item_id item_type] if user.present?
  end
end
