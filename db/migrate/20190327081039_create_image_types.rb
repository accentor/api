class CreateImageTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :image_types do |t|
      t.string :extension, null: false
      t.string :mimetype, null: false

      t.index :extension, unique: true
    end
  end
end
