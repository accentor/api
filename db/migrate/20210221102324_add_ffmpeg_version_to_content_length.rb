class AddFfmpegVersionToContentLength < ActiveRecord::Migration[6.1]
  def change
    add_column :content_lengths, :ffmpeg_version, :string
    ContentLength.update_all(ffmpeg_version: Rails.application.config.FFMPEG_VERSION)
    change_column_null :content_lengths, :ffmpeg_version, false
  end
end
