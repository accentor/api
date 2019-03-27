class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :path, null: false

      t.index :path, unique: true
    end
  end
end
