# == Schema Information
#
# Table name: labels
#
#  id   :bigint(8)        not null, primary key
#  name :string           not null
#

class Label < ApplicationRecord
  has_many :album_labels, dependent: :destroy
  has_many :albums, through: :album_labels, source: :album

  validates :name, presence: true
end
