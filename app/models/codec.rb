# == Schema Information
#
# Table name: codecs
#
#  id        :bigint(8)        not null, primary key
#  mimetype  :string           not null
#  extension :string           not null
#

class Codec < ApplicationRecord
  has_many :audio_files, dependent: :restrict_with_error

  validates :mimetype, presence: true
  validates :extension, presence: true, uniqueness: true
end
