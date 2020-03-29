class CoverFilenamesController < ApplicationController
  before_action :set_cover_filename, only: %i[show destroy]

  def index
    authorize CoverFilename
    @cover_filenames = apply_scopes(policy_scope(CoverFilename))
                       .order(id: :asc)
                       .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@cover_filenames)
    render json: @cover_filenames
  end

  def show
    render json: @cover_filename
  end

  def create
    authorize CoverFilename
    @cover_filename = CoverFilename.new(permitted_attributes(CoverFilename))

    if @cover_filename.save
      render json: @cover_filename, status: :created
    else
      render json: @cover_filename.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @cover_filename.errors, status: :unprocessable_entity unless @cover_filename.destroy
  end

  private

  def set_cover_filename
    @cover_filename = CoverFilename.find(params[:id])
    authorize @cover_filename
  end
end
