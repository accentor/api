class CodecConversionsController < ApplicationController
  before_action :set_codec_conversion, only: %i[show update destroy]

  has_scope :by_codec, as: 'codec'

  def index
    authorize CodecConversion
    @codec_conversions = apply_scopes(policy_scope(CodecConversion))
                         .order(id: :asc)
                         .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@codec_conversions)

    render json: @codec_conversions.map { transform_codec_conversion_for_json(it) }
  end

  def show
    render json: transform_codec_conversion_for_json(@codec_conversion)
  end

  def create
    authorize CodecConversion
    @codec_conversion = CodecConversion.new(permitted_attributes(CodecConversion))

    if @codec_conversion.save
      render json: transform_codec_conversion_for_json(@codec_conversion), status: :created
    else
      render json: @codec_conversion.errors, status: :unprocessable_entity
    end
  end

  def update
    if @codec_conversion.update(permitted_attributes(CodecConversion))
      render json: transform_codec_conversion_for_json(@codec_conversion), status: :ok
    else
      render json: @codec_conversion.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @codec_conversion.errors, status: :unprocessable_entity unless @codec_conversion.destroy
  end

  private

  def set_codec_conversion
    @codec_conversion = CodecConversion.find(params[:id])
    authorize @codec_conversion
  end

  def transform_codec_conversion_for_json(codec_conversion)
    %i[id name ffmpeg_params resulting_codec_id].index_with { codec_conversion.send(it) }
  end
end
