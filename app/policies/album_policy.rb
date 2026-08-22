class AlbumPolicy < ApplicationPolicy
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
      [
        :title,
        :release,
        :review_comment,
        :edition,
        :edition_description,
        { image: %i[data filename mimetype],
          album_artists: %i[artist_id name order separator],
          album_labels: %i[label_id catalogue_number] }
      ]
    else
      [:review_comment]
    end
  end
end
