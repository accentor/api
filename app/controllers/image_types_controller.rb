class ImageTypesController < ApplicationController
  before_action :set_image_type, only: %i[show update destroy]

  def index
    authorize ImageType
    @image_types = apply_scopes(policy_scope(ImageType))
                   .order(id: :asc)
                   .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@image_types)

    render json: @image_types.map { |it| transform_image_type_for_json(it) }
  end

  def show
    render json: transform_image_type_for_json(@image_type)
  end

  def create
    authorize ImageType
    @image_type = ImageType.new(permitted_attributes(ImageType))

    if @image_type.save
      render json: transform_image_type_for_json(@image_type), status: :created
    else
      render json: @image_type.errors, status: :unprocessable_entity
    end
  end

  def update
    if @image_type.update(permitted_attributes(@image_type))
      render json: transform_image_type_for_json(@image_type), status: :ok
    else
      render json: @image_type.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @image_type.errors, status: :unprocessable_entity unless @image_type.destroy
  end

  private

  def set_image_type
    @image_type = ImageType.find(params[:id])
    authorize @image_type
  end

  def transform_image_type_for_json(image_type)
    %i[id extension mimetype].index_with { |it| image_type.send(it) }
  end
end
