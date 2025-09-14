class RescansController < ApplicationController
  before_action :set_rescan, only: %i[show start]

  def index
    authorize RescanRunner
    @rescans = policy_scope(RescanRunner).paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@rescans)

    render json: @rescans.map { transform_rescan_runner_for_json(it) }
  end

  def show
    render json: transform_rescan_runner_for_json(@rescan)
  end

  def start
    @rescan.schedule
    render json: transform_rescan_runner_for_json(@rescan)
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

  def transform_rescan_runner_for_json(rescan_runner)
    %i[id error_text warning_text processed running finished_at location_id created_at updated_at].index_with { rescan_runner.send(it) }
  end
end
