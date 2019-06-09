class CodecConversionsController < ApplicationController
  before_action :set_codec_conversion, only: [:show, :update, :destroy]

  has_scope :by_codec, as: 'codec'

  def index
    authorize CodecConversion
    @codec_conversions = apply_scopes(policy_scope(CodecConversion))
                             .order(id: :asc)
                             .paginate(page: params[:page])
  end

  def show
  end

  def create
    authorize CodecConversion
    @codec_conversion = CodecConversion.new(permitted_attributes(CodecConversion))

    if @codec_conversion.save
      render :show, status: :created
    else
      render json: @codec_conversion.errors, status: :unprocessable_entity
    end
  end

  def update
    if @codec_conversion.update(permitted_attributes(CodecConversion))
      render :show, status: :ok
    else
      render json: @codec_conversion.errors, status: :unprocessable_entity
    end
  end

  def destroy
    unless @codec_conversion.destroy
      render json: @codec_conversion.errors, status: :unprocessable_entity
    end
  end

  private

  def set_codec_conversion
    @codec_conversion = CodecConversion.find(params[:id])
    authorize @codec_conversion
  end

end
