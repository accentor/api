class RescanRunnerPolicy < ApplicationPolicy
  def show?
    user&.moderator?
  end

  def start?
    user&.moderator?
  end
end
