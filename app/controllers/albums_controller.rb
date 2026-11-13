class AlbumsController < ApplicationController
  include ImageRendering

  before_action :set_album, only: %i[show update destroy merge]

  has_scope :by_filter, as: 'filter'
  has_scope :by_label, as: 'label'
  has_scope :by_labels, as: 'labels', type: :array
  has_scope :by_artist, as: 'artist_id'

  def index
    authorize Album
    scoped_albums = apply_scopes(policy_scope(Album))
    @albums = scoped_albums.includes(:album_artists, :album_labels, image: [{ image_attachment: :blob }, :image_type])
                           .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@albums)

    render json: @albums.map { transform_album_for_json(it) } if stale?(scope: scoped_albums)
  end

  def show
    render json: transform_album_for_json(@album)
  end

  def create
    authorize Album
    @album = Album.new
    if SaveAlbumService.call(@album, permitted_attributes(@album))
      render json: transform_album_for_json(@album), status: :created
    else
      render json: transform_errors_for_json(@album), status: :unprocessable_content
    end
  end

  def update
    if SaveAlbumService.call(@album, permitted_attributes(@album))
      render json: transform_album_for_json(@album), status: :ok
    else
      render json: transform_errors_for_json(@album), status: :unprocessable_content
    end
  end

  def destroy
    render json: transform_errors_for_json(@album), status: :unprocessable_content unless @album.destroy
  end

  def destroy_empty
    authorize Album
    Album.where.not(id: Track.select(:album_id).distinct).destroy_all
  end

  def merge
    render json: transform_errors_for_json(@album), status: :unprocessable_content unless @album.merge(Album.find(params.expect(:source_id)))
  end

  private

  def set_album
    @album = policy_scope(Album).find(params.expect(:id))
    authorize @album
  end

  def transform_album_for_json(album)
    result = %i[id title normalized_title release review_comment edition edition_description created_at updated_at].index_with { album.send(it) }
    %i[image image100 image250 image500 image_type].each do |attr|
      result[attr] = send(attr, album)
    end
    result[:album_artists] = album.album_artists.map { transform_album_artist_for_json(it) }
    result[:album_labels] = album.album_labels.map { transform_album_label_for_json(it) }
    result
  end

  def transform_album_artist_for_json(album_artist)
    %i[artist_id name normalized_name order separator].index_with { |attr| album_artist.send(attr) }
  end

  def transform_album_label_for_json(album_label)
    %i[label_id catalogue_number].index_with { |attr| album_label.send(attr) }
  end
end
