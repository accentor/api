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
    create?
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
    [:title, :number, :album_id, genre_ids: [], track_artists: %i[artist_id name role]]
  end
end
