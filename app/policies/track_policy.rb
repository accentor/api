class TrackPolicy < ApplicationPolicy
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
  def audio? = show?
  def download? = audio?
  def merge? = create?

  def permitted_attributes
    if user.moderator?
      [:title, :number, :album_id, :review_comment, { genre_ids: [], track_artists: %i[artist_id name role order hidden] }]
    else
      [:review_comment]
    end
  end
end
