class AuthTokenPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def index?
    user.present?
  end

  def show?
    user.present? && record.user == user
  end

  def create?
    true
  end

  def destroy?
    show?
  end

  def permitted_attributes
    [:user_agent]
  end
end
