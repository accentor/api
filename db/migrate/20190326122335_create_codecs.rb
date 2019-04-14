class CreateCodecs < ActiveRecord::Migration[5.2]
  def change
    create_table :codecs do |t|
      t.string :mimetype, null: false
      t.string :extension, null: false, index: {unique: true}
    end
  end
end
