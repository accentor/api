class CreateCoverFilenames < ActiveRecord::Migration[5.2]
  def change
    create_table :cover_filenames do |t|
      t.string :filename, null: false, index: {unique: true}
    end
  end
end
