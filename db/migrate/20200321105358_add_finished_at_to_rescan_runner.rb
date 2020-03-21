class AddFinishedAtToRescanRunner < ActiveRecord::Migration[6.0]
  def change
    add_column :rescan_runners, :finished_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
