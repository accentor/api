# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :password_digest, null: false
      t.integer :permission, null: false, default: 0

      t.index :name, unique: true
    end
  end
end
