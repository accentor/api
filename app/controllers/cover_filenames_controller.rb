class CoverFilenamesController < ApplicationController
  before_action :set_cover_filename, only: [:show, :destroy]

  def index
    authorize CoverFilename
    @cover_filenames = apply_scopes(policy_scope(CoverFilename))
                           .order(id: :asc)
                           .paginate(page: params[:page])
  end

  def show
  end

  def create
    authorize CoverFilename
    @cover_filename = CoverFilename.new(permitted_attributes(CoverFilename))

    if @cover_filename.save
      render :show, status: :created
    else
      render json: @cover_filename.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @cover_filename.destroy
  end

  private

  def set_cover_filename
    @cover_filename = CoverFilename.find(params[:id])
    authorize @cover_filename
  end

end
