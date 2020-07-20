class CreateTranscodedItems < ActiveRecord::Migration[6.0]
  def change
    create_table :transcoded_items do |t|
      t.string :path, null: false
      t.timestamp :last_used, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.references :audio_file, null: false, foreign_key: true
      t.references :codec_conversion, null: false, foreign_key: true

      t.timestamps

      t.index [:audio_file_id, :codec_conversion_id], unique: true
      t.index :path, unique: true
    end
  end
end
