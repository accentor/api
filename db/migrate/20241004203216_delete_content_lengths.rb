class DeleteContentLengths < ActiveRecord::Migration[7.2]
  def up
    drop_table :content_lengths
  end

  def down
    create_table :content_lengths do |t|
      t.references :audio_file, foreign_key: true, null: false
      t.references :codec_conversion, foreign_key: true, null: false
      t.integer :length, null: false

      t.index [:audio_file_id, :codec_conversion_id], unique: true
    end
  end
end
