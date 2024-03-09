class PlaylistPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where.not(access: :secret).or(scope.where(access: :secret, user_id: user.id))
    end
  end

  def index?
    user.present?
  end

  def show?
    user.present? && (!record.secret? || user.id == record.user_id)
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

  def add_item?
    update?
  end

  def permitted_attributes
    [:name, :description, :playlist_type, { item_ids: [] }, :access]
  end

  def permitted_attributes_for_add_item
    %i[item_id item_type]
  end
end
