class ArtistPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index? = true
  def show? = true
  def create? = user.moderator?
  def update? = true
  def destroy? = create?
  def destroy_empty? = create?
  def merge? = create?

  def permitted_attributes
    if user.moderator?
      [:name, :review_comment, { image: %i[data filename mimetype] }]
    else
      [:review_comment]
    end
  end
end
