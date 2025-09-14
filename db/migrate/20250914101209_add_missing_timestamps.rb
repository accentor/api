class AddMissingTimestamps < ActiveRecord::Migration[8.0]
  def change
    %w[AlbumArtist AlbumLabel AudioFile AuthToken CodecConversion Codec CoverFilename Genre Image ImageType Label Location Play RescanRunner TrackArtist User].each do |model_name|
      klass = model_name.constantize
  
      add_timestamps klass.table_name, null: true

      up_only do
        klass.touch_all(:created_at)
      end

      change_table klass.table_name, bulk: true do |t|
        t.change_null :created_at, false
        t.change_null :updated_at, false
      end 
    end
  end
end
