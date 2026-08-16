class PlayPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user:)
    end
  end

  def index? = true
  def create? = true
  def stats? = true

  def permitted_attributes
    %i[track_id played_at]
  end
end
