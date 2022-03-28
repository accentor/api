class PlaylistsController < ApplicationController
  before_action :set_playlist, only: %i[show update destroy]

  def index
    authorize Playlist
    @playlists = apply_scopes(policy_scope(Playlist))
                 .includes(:items)
                 .order(id: :asc)
                 .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@playlists)
    render json: @playlists
  end

  def show
    render json: @playlist
  end

  def create
    authorize Playlist
    @playlist = Playlist.new(transformed_attributes)

    if @playlist.save
      render json: @playlist, status: :created
    else
      render json: @playlist.errors, status: :unprocessable_entity
    end
  end

  def update
    if @playlist.update(transformed_attributes)
      render json: @playlist, status: :ok
    else
      render json: @playlist.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @playlist.errors, status: :unprocessable_entity unless @playlist.destroy
  end

  private

  def set_playlist
    @playlist = Playlist.find(params[:id])
    authorize @playlist
  end

  def transformed_attributes
    attributes = permitted_attributes(@playlist || Playlist)

    if attributes[:personal].present?
      attributes[:user_id] = attributes.delete(:personal) ? current_user.id : nil
    end

    attributes
  end
end
