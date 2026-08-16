class AuthTokenPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user:)
    end
  end

  def index? = true
  def show? = record.user == user
  def destroy? = show?
end
