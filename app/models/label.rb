# == Schema Information
#
# Table name: labels
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#

class Label < ApplicationRecord
  include HasNormalized

  has_many :album_labels, dependent: :destroy
  has_many :albums, through: :album_labels, source: :album

  validates :name, presence: true

  normalized_col_generator :name

  def merge(other)
    other.album_labels.find_each do |al|
      al.update(label_id: id) unless self.albums.include?(al.album)
    end
    other.destroy
  end
end
