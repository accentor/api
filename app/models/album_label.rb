# == Schema Information
#
# Table name: album_labels
#
#  id               :bigint           not null, primary key
#  catalogue_number :string
#  album_id         :bigint           not null
#  label_id         :bigint           not null
#
# Indexes
#
#  index_album_labels_on_album_id               (album_id)
#  index_album_labels_on_album_id_and_label_id  (album_id,label_id) UNIQUE
#  index_album_labels_on_label_id               (label_id)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#  fk_rails_...  (label_id => labels.id)
#

class AlbumLabel < ApplicationRecord
  belongs_to :album
  belongs_to :label

  validates :album, uniqueness: { scope: :label }
end
