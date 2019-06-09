# == Schema Information
#
# Table name: cover_filenames
#
#  id       :bigint(8)        not null, primary key
#  filename :string           not null
#

class CoverFilename < ApplicationRecord
  validates :filename, presence: true, uniqueness: true

  before_validation :downcase

  def downcase
    self.filename = filename.downcase
  end
end
