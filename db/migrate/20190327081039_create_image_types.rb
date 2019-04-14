class CreateImageTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :image_types do |t|
      t.string :extension, null: false, index: {unique: true}
      t.string :mimetype, null: false
    end
  end
end
