class AddReviewCommentToTrack < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :review_comment, :string
    Track.update_all(review_comment: 'New track')
  end
end
