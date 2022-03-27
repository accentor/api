class PlaylistPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: [nil, user.id])
    end
  end

  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user.present? && (record.shared? || record.user_id == user.id)
  end

  def destroy?
    update?
  end

  def permitted_attributes
    [:name, :description, :playlist_type, { item_ids: [] }, :personal]
  end
end
