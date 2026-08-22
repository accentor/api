class LocationPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, scope)
      super

      raise Pundit::NotAuthorizedError.new(message: 'must be at least moderator', policy: self, record: scope.none.model) unless user.moderator?
    end

    def resolve
      scope.all
    end
  end

  def initialize(user, record)
    super

    raise Pundit::NotAuthorizedError.new(message: 'must be at least moderator', policy: self, record:) unless user.moderator?
  end

  def index? = true
  def show? = true
  def create? = true
  def destroy? = true

  def permitted_attributes
    [:path]
  end
end
