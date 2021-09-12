class RescanController < ApplicationController
  before_action :set_rescan

  def show
    render json: @rescan
  end

  def start
    @rescan.schedule
    render json: @rescan
  end

  private

  def set_rescan
    @rescan = RescanRunner.instance
    authorize @rescan
  end
end
