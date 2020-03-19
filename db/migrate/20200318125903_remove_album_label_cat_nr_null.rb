class RemoveAlbumLabelCatNrNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :album_labels, :catalogue_number, true

    AlbumLabel.where(catalogue_number: "none").update_all(catalogue_number: nil)
    end
  end
end
