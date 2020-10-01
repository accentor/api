class CreatePlays < ActiveRecord::Migration[6.0]
  def change
    create_table :plays do |t|
      t.references :track, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :played_at, null: false
    end
  end
end
