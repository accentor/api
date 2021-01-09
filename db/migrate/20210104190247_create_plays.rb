class CreatePlays < ActiveRecord::Migration[6.1]
  def change
    create_table :plays do |t|
      t.references :track, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :played_at, null: false
      t.index [:user_id, :track_id]
    end
  end
end
