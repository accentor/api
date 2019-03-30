# == Schema Information
#
# Table name: genres
#
#  id   :bigint(8)        not null, primary key
#  name :string           not null
#

class Genre < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
