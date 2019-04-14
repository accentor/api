class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.references :image_type, null: false, foreign_key: true
    end
  end
end
