class CreatePlayCounts < ActiveRecord::Migration[7.0]
  def change
    create_view :play_counts
  end
end
