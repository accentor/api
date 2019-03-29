class CreateCodecConversions < ActiveRecord::Migration[5.2]
  def change
    create_table :codec_conversions do |t|
      t.string :name, null: false, index: {unique: true}
      t.string :ffmpeg_params, null: false
      t.references :resulting_codec, null: false, foreign_key: {to_table: :codecs}
    end
  end
end
