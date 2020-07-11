class AddSampleRateAndBitDepthToAudioFile < ActiveRecord::Migration[6.0]
  def up
    add_column :audio_files, :sample_rate, :integer
    add_column :audio_files, :bit_depth, :integer

    AudioFile.update_all(sample_rate: 0, bit_depth: 0)
    AudioFile.find_each do |af|
      af.delay(priority: 9).check_file_attributes
    end

    change_column_null :audio_files, :sample_rate, false
    change_column_null :audio_files, :bit_depth, false
  end

  def down
    remove_column :audio_files, :sample_rate
    remove_column :audio_files, :bit_depth
  end
end
