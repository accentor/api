class CreateAudioFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :audio_files do |t|
      t.references :location, null: false, foreign_key: true
      t.references :codec, null: false, foreign_key: true
      t.string :filename, null: false
      t.integer :length, null: false
      t.integer :bitrate, null: false

      t.index [:location_id, :filename], unique: true
    end
  end
end
