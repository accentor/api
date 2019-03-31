# == Schema Information
#
# Table name: genres
#
#  id   :bigint(8)        not null, primary key
#  name :string           not null
#

class Genre < ApplicationRecord
  has_and_belongs_to_many :tracks

  validates :name, presence: true, uniqueness: true
end
