class CreateContentLengths < ActiveRecord::Migration[5.2]
  def change
    create_table :content_lengths do |t|
      t.references :audio_file, foreign_key: true, null: false
      t.references :codec_conversion, foreign_key: true, null: false
      t.integer :length, null: false

      t.index [:audio_file_id, :codec_conversion_id], unique: true
    end
  end
end
