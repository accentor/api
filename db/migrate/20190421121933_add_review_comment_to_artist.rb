class AddReviewCommentToArtist < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :review_comment, :string
    Artist.update_all(review_comment: 'New artist')
  end
end
