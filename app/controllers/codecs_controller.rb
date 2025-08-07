class CodecsController < ApplicationController
  before_action :set_codec, only: %i[show update destroy]

  def index
    authorize Codec
    @codecs = apply_scopes(policy_scope(Codec))
              .order(id: :asc)
              .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@codecs)

    render json: @codecs.map { transform_codec_for_json(it) }
  end

  def show
    render json: transform_codec_for_json(@codec)
  end

  def create
    authorize Codec
    @codec = Codec.new(permitted_attributes(Codec))

    if @codec.save
      render json: transform_codec_for_json(@codec), status: :created
    else
      render json: @codec.errors, status: :unprocessable_content
    end
  end

  def update
    if @codec.update(permitted_attributes(@codec))
      render json: transform_codec_for_json(@codec), status: :ok
    else
      render json: @codec.errors, status: :unprocessable_content
    end
  end

  def destroy
    render json: @codec.errors, status: :unprocessable_content unless @codec.destroy
  end

  private

  def set_codec
    @codec = Codec.find(params[:id])
    authorize @codec
  end

  def transform_codec_for_json(codec)
    %i[id mimetype extension].index_with { codec.send(it) }
  end
end
