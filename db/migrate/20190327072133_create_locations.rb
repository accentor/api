class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :path, null: false, index: {unique: true}
    end
  end
end
