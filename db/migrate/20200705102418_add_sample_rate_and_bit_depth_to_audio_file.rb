class AddSampleRateAndBitDepthToAudioFile < ActiveRecord::Migration[6.0]
  def up
    add_column :audio_files, :sample_rate, :integer
    add_column :audio_files, :bit_depth, :integer

    AudioFile.find_each do |af|
      next unless af.check_self
      tag = WahWah.open(af.full_path)
      
      # Use update_columns so we don't trigger after_save queue_content_length_calculations
      af.update_columns(sample_rate: tag.sample_rate || 0, bit_depth: tag.bit_depth || 0)
    end

    change_column_null :audio_files, :sample_rate, false
    change_column_null :audio_files, :bit_depth, false
  end

  def down
    remove_column :audio_files, :sample_rate
    remove_column :audio_files, :bit_depth
  end
end
