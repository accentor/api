class CoverFilename < ApplicationRecord
  validates :filename, presence: true, uniqueness: true
end
