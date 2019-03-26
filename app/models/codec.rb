class Codec < ApplicationRecord
  validates :mimetype, presence: true
  validates :extension, presence: true, uniqueness: true
end
