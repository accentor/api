class CreateRescanRunners < ActiveRecord::Migration[5.2]
  def change
    create_table :rescan_runners do |t|
      t.text :warning_text
      t.text :error_text
      t.integer :processed, default: 0, null: false
      t.boolean :running, default: false, null: false
    end
  end
end
