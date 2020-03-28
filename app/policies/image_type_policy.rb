class ImageTypePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.present?
  end

  def show?
    index?
  end

  def create?
    user&.moderator?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes_for_create
    %i[mimetype extension]
  end

  def permitted_attributes_for_update
    [:mimetype]
  end
end
