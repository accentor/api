class RescansController < ApplicationController
  before_action :set_rescan, only: %i[show start]

  def index
    authorize RescanRunner
    @rescans = policy_scope(RescanRunner).paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@rescans)
    render json: @rescans
  end

  def show
    render json: @rescan
  end

  def start
    @rescan.schedule
    render json: @rescan
  end

  def start_all
    authorize RescanRunner
    RescanRunner.schedule_all
  end

  private

  def set_rescan
    @rescan = RescanRunner.find(params[:id])
    authorize @rescan
  end
end
