class RescanRunnerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all if user&.moderator?
    end
  end

  def index?
    user&.moderator?
  end

  def show?
    user&.moderator?
  end

  def start?
    user&.moderator?
  end

  def start_all?
    user&.moderator?
  end
end
