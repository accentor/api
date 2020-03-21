class AddLastScanToRescanRunner < ActiveRecord::Migration[6.0]
  def change
    add_column :rescan_runners, :last_scan, :datetime
  end
end
