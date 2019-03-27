class CreateCodecConversions < ActiveRecord::Migration[5.2]
  def change
    create_table :codec_conversions do |t|
      t.string :name, null: false
      t.string :ffmpeg_params, null: false
      t.references :resulting_codec, null: false, foreign_key: {to_table: :codecs}

      t.index :name, unique: true
    end
  end
end
