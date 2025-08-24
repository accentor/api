class AddMissingTimestamps < ActiveRecord::Migration[8.0]
  def change
    add_timestamps :genres, null: true
    add_timestamps :labels, null: true

    up_only do
      Genre.touch_all(:created_at)
      Label.touch_all(:created_at)
    end

    change_table :genres, bulk: true do |t|
      t.change_null :created_at, false
      t.change_null :updated_at, false
    end
    change_table :labels, bulk: true do |t|
      t.change_null :created_at, false
      t.change_null :updated_at, false
    end
  end
end
