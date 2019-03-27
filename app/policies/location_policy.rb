class LocationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user&.moderator?
  end

  def show?
    user&.moderator?
  end

  def create?
    user&.moderator?
  end

  def destroy?
    user&.moderator?
  end

  def permitted_attributes
    [:path]
  end
end
