class CodecsController < ApplicationController
  before_action :set_codec, only: [:show, :update, :destroy]

  def index
    authorize Codec
    @codecs = apply_scopes(policy_scope(Codec))
  end

  def show
  end

  def create
    authorize Codec
    @codec = Codec.new(permitted_attributes(Codec))

    if @codec.save
      render :show, status: :created
    else
      render json: @codec.errors, status: :unprocessable_entity
    end
  end

  def update
    if @codec.update(permitted_attributes(@codec))
      render :show, status: :ok
    else
      render json: @codec.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @codec.destroy
  end

  private

  def set_codec
    @codec = Codec.find(params[:id])
    authorize @codec
  end
end
