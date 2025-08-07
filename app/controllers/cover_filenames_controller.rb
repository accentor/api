class CoverFilenamesController < ApplicationController
  before_action :set_cover_filename, only: %i[show destroy]

  def index
    authorize CoverFilename
    @cover_filenames = apply_scopes(policy_scope(CoverFilename))
                       .order(id: :asc)
                       .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@cover_filenames)

    render json: @cover_filenames.map { transform_cover_filename_for_json(it) }
  end

  def show
    render json: transform_cover_filename_for_json(@cover_filename)
  end

  def create
    authorize CoverFilename
    @cover_filename = CoverFilename.new(permitted_attributes(CoverFilename))

    if @cover_filename.save
      render json: transform_cover_filename_for_json(@cover_filename), status: :created
    else
      render json: @cover_filename.errors, status: :unprocessable_content
    end
  end

  def destroy
    render json: @cover_filename.errors, status: :unprocessable_content unless @cover_filename.destroy
  end

  private

  def set_cover_filename
    @cover_filename = CoverFilename.find(params[:id])
    authorize @cover_filename
  end

  def transform_cover_filename_for_json(cover_filename)
    %i[id filename].index_with { cover_filename.send(it) }
  end
end
