class GenresController < ApplicationController
  before_action :set_genre, only: [:show, :update, :destroy]

  def index
    authorize Genre
    @genres = apply_scopes(policy_scope(Genre))
  end

  def show
  end

  def create
    authorize Genre
    @genre = Genre.new(permitted_attributes(Genre))

    if @genre.save
      render :show, status: :created
    else
      render json: @genre.errors, status: :unprocessable_entity
    end
  end

  def update
    if @genre.update(permitted_attributes(@genre))
      render :show, status: :ok
    else
      render json: @genre.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @genre.destroy
  end

  private

  def set_genre
    @genre = Genre.find(params[:id])
    authorize @genre
  end
end
