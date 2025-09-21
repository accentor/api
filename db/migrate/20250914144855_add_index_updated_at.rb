class AddIndexUpdatedAt < ActiveRecord::Migration[8.0]
  def change
    add_index :albums, :updated_at
    add_index :artists, :updated_at
    add_index :plays, [:user_id, :updated_at]
    add_index :tracks, :updated_at
  end
end
