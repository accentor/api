class PlaysController < ApplicationController
  has_scope :by_album, as: 'album_id'

  def index
    authorize Play
    @plays = apply_scopes(policy_scope(Play))
             .order(id: :desc)
             .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@plays)

    render json: @plays, each_serializer: PlaySerializer
  end

  def create
    authorize Play
    @play = Play.new(transformed_attributes)

    if @play.save
      render json: @play, status: :created
    else
      render json: @play.errors, status: :unprocessable_entity
    end
  end

  private

  def transformed_attributes
    permitted_attributes(Play).merge(user: current_user)
  end
end
