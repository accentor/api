class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record

    raise Pundit::NotAuthorizedError.new(message: 'must be logged in', policy: self, record:) if user.blank?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope

      raise Pundit::NotAuthorizedError.new(message: 'must be logged in', policy: self, record: scope.none.model) if user.blank?
    end
  end
end
