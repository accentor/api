class RescanController < ApplicationController
  before_action :set_rescan

  def show; end

  def start
    @rescan.delay(priority: 0).run
    render :show
  end

  private

  def set_rescan
    @rescan = RescanRunner.first || RescanRunner.create
    authorize @rescan, policy_class: RescanPolicy
  end
end
