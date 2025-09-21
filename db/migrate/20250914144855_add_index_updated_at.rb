class AddIndexUpdatedAt < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :albums, :updated_at, algorithm: :concurrently
    add_index :artists, :updated_at, algorithm: :concurrently
    add_index :plays, [:user_id, :updated_at], algorithm: :concurrently
    add_index :tracks, :updated_at, algorithm: :concurrently
  end
end
