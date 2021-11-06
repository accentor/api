# == Schema Information
#
# Table name: locations
#
#  id   :bigint           not null, primary key
#  path :string           not null
#

class Location < ApplicationRecord
  has_many :audio_files, dependent: :destroy

  validates :path, presence: true, uniqueness: true
  validate :cant_be_subdir_of_other_location
  validate :cant_be_parent_of_other_location

  private

  def cant_be_subdir_of_other_location
    errors.add(:path, 'path-is-subdirectoy') unless Location.where('path LIKE ?', "#{path}%").empty?
  end

  def cant_be_parent_of_other_location
    errors.add(:path, 'path-is-parent') unless Location.where("? LIKE path || '%'", path).empty?
  end
end
