class UserPolicy < ApplicationPolicy
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
    user&.admin?
  end

  def update?
    user == record || user&.admin?
  end

  def destroy?
    update?
  end

  def permitted_attributes
    if user.admin?
      %i[name password password_confirmation permission]
    else
      %i[name password password_confirmation]
    end
  end

end
