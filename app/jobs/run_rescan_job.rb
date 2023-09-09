class RunRescanJob < ApplicationJob
  queue_as :rescans
  queue_with_priority 20

  def perform(rescan_runner)
    rescan_runner.run
  end
end
