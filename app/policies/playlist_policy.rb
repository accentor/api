class PlaylistPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where.not(access: :secret).or(scope.where(access: :secret, user_id: user.id))
    end
  end

  def index? = true
  def show? = !record.secret? || user.id == record.user_id
  def create? = true
  def update? = record.shared? || record.user_id == user.id
  def destroy? = update?
  def add_item? = update?

  def permitted_attributes
    [:name, :description, :playlist_type, { item_ids: [] }, :access]
  end

  def permitted_attributes_for_add_item
    %i[item_id item_type]
  end
end
