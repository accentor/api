class AuthTokenPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user:)
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
    %i[user_agent application]
  end
end
