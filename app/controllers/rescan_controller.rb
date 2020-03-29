class RescanController < ApplicationController
  before_action :set_rescan

  def show
    render json: @rescan
  end

  def start
    @rescan.delay(priority: 0).run
    render json: @rescan
  end

  private

  def set_rescan
    @rescan = RescanRunner.first || RescanRunner.create
    authorize @rescan
  end
end
