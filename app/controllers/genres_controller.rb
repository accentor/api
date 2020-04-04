class GenresController < ApplicationController
  before_action :set_genre, only: %i[show update destroy merge]

  def index
    authorize Genre
    @genres = apply_scopes(policy_scope(Genre))
              .order(id: :asc)
              .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@genres)
    render json: @genres
  end

  def show
    render json: @genre
  end

  def create
    authorize Genre
    @genre = Genre.new(permitted_attributes(Genre))

    if @genre.save
      render json: @genre, status: :created
    else
      render json: @genre.errors, status: :unprocessable_entity
    end
  end

  def update
    if @genre.update(permitted_attributes(@genre))
      render json: @genre, status: :ok
    else
      render json: @genre.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @genre.errors, status: :unprocessable_entity unless @genre.destroy
  end

  def destroy_empty
    authorize Genre
    Genre.left_outer_joins(:tracks).where(tracks: { id: nil }).destroy_all
  end

  def merge
    @genre.merge(Genre.find(params[:other_genre_id]))
    # We don't do error handling here. The merge action isn't supposed to fail.
    render :show, status: :ok
  end

  private

  def set_genre
    @genre = Genre.find(params[:id])
    authorize @genre
  end
end
