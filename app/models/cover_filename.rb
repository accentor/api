# == Schema Information
#
# Table name: cover_filenames
#
#  id       :bigint           not null, primary key
#  filename :string           not null
#
# Indexes
#
#  index_cover_filenames_on_filename  (filename) UNIQUE
#

class CoverFilename < ApplicationRecord
  validates :filename, presence: true, uniqueness: true

  before_validation :downcase

  def downcase
    self.filename = filename.downcase
  end
end
