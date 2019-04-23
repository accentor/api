class AddReviewCommentToAlbum < ActiveRecord::Migration[5.2]
  def change
    add_column :albums, :review_comment, :string
    Album.update_all(review_comment: 'New album')
  end
end
