class RescanPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user&.moderator?
  end

  def start?
    user&.moderator?
  end
end
