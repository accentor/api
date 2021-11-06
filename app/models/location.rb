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
  validate :cant_be_parent_or_subdir_of_other_location

  def expanded_path
    Pathname.new(path).expand_path
  end

  private

  def cant_be_parent_or_subdir_of_other_location
    Location.find_each do |l|
      errors.add(:path, 'path-is-subdirectoy') if expanded_path.fnmatch?(File.join(l.expanded_path, '**'))
      errors.add(:path, 'path-is-parent') if l.expanded_path.fnmatch?(File.join(expanded_path, '**'))
    end
  end
end
