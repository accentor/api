class AddEditionInformationToAlbum < ActiveRecord::Migration[5.2]
  def change
    add_column :albums, :edition, :date
    add_column :albums, :edition_description, :string
  end
end
