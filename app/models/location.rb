# == Schema Information
#
# Table name: locations
#
#  id   :bigint           not null, primary key
#  path :string           not null
#
# Indexes
#
#  index_locations_on_path  (path) UNIQUE
#

class Location < ApplicationRecord
  has_many :audio_files, dependent: :destroy
  has_one :rescan_runner, dependent: :destroy

  after_create :create_runner

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

  def create_runner
    runner = RescanRunner.create(location: self)
    runner.schedule
  end
end
