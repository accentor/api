class RemoveLastUsedFromTranscodedItems < ActiveRecord::Migration[7.2]
  def up
    # Delete all old transcoded items, since these were transcoded with artifacts
    TranscodedItem.delete_all

    change_table :transcoded_items do |t|
      t.remove :last_used, :path
      t.string :uuid, null: false
      t.index [:codec_conversion_id, :uuid], unique: true
    end

    CodecConversion.find_each(&:reset_transcoded_items)
  end

  def down
    change_table :transcoded_items do |t|
      t.remove :uuid
      t.timestamp :last_used, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.string :path, null: false, unique: true
    end
  end
end
