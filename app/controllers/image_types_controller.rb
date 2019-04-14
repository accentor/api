class ImageTypesController < ApplicationController
  before_action :set_image_type, only: [:show, :update, :destroy]

  def index
    authorize ImageType
    @image_types = apply_scopes(policy_scope(ImageType))
  end

  def show
  end

  def create
    authorize ImageType
    @image_type = ImageType.new(permitted_attributes(ImageType))

    if @image_type.save
      render :show, status: :created
    else
      render json: @image_type.errors, status: :unprocessable_entity
    end
  end

  def update
    if @image_type.update(permitted_attributes(@image_type))
      render :show, status: :ok
    else
      render json: @image_type.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @image_type.destroy
  end

  private

  def set_image_type
    @image_type = ImageType.find(params[:id])
    authorize @image_type
  end

end
