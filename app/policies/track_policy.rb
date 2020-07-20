class TrackPolicy < ApplicationPolicy
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
    user&.moderator?
  end

  def update?
    user
  end

  def destroy?
    create?
  end

  def destroy_empty?
    create?
  end

  def audio?
    index?
  end

  def merge?
    create?
  end

  def permitted_attributes
    if user.moderator?
      [:title, :number, :album_id, :review_comment, { genre_ids: [], track_artists: %i[artist_id name role order] }]
    else
      [:review_comment]
    end
  end
end
