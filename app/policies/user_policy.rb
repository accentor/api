class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index? = true
  def show? = true
  def create? = user.admin?
  def update? = user == record || create?
  def destroy? = update?

  def permitted_attributes
    if user.admin?
      %i[name password password_confirmation permission]
    else
      %i[name password password_confirmation]
    end
  end
end
