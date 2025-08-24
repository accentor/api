class PlaylistsController < ApplicationController
  before_action :set_playlist, only: %i[show update destroy add_item]

  def index
    authorize Playlist
    scoped_playlists = apply_scopes(policy_scope(Playlist)).with_item_ids.order(id: :asc)
    @playlists = scoped_playlists.paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@playlists)

    render json: @playlists.map { transform_playlist_for_json(it) } if stale?(etag: scoped_playlists)
  end

  def show
    render json: transform_playlist_for_json(@playlist)
  end

  def create
    authorize Playlist
    @playlist = Playlist.new(permitted_attributes(Playlist).merge({ user: current_user }))

    if @playlist.save
      render json: transform_playlist_for_json(@playlist), status: :created
    else
      render json: @playlist.errors, status: :unprocessable_content
    end
  end

  def update
    if @playlist.update(permitted_attributes(@playlist))
      render json: transform_playlist_for_json(@playlist), status: :ok
    else
      render json: @playlist.errors, status: :unprocessable_content
    end
  end

  def destroy
    render json: @playlist.errors, status: :unprocessable_content unless @playlist.destroy
  end

  def add_item
    @item = @playlist.items.create(permitted_attributes(@playlist))

    render json: @item.errors, status: :unprocessable_content unless @item.save
  end

  private

  def set_playlist
    @playlist = Playlist.find(params[:id])
    authorize @playlist
  end

  def transform_playlist_for_json(playlist)
    %i[id name description user_id playlist_type created_at updated_at item_ids access].index_with { playlist.send(it) }
  end
end
