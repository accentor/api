# == Schema Information
#
# Table name: transcoded_items
#
#  id                  :bigint           not null, primary key
#  last_used           :datetime         not null
#  path                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#
class TranscodedItem < ApplicationRecord
  BASE_PATH = Rails.configuration.transcode_cache_path

  belongs_to :audio_file
  belongs_to :codec_conversion

  validates :path, presence: true, uniqueness: true

  after_create -> { ConvertTranscodeJob.perform_later(self) }
  after_destroy :delete_file

  def initialize(params)
    super
    self.path = random_path
  end

  def do_conversion
    tmppath = random_path
    FileUtils.mkdir_p Pathname.new(tmppath).parent
    File.open(tmppath, 'w') { |f| IO.copy_stream(audio_file.convert(codec_conversion), f) }
    FileUtils.mkdir_p Pathname.new(path).parent
    FileUtils.mv(tmppath, path)
  end

  private

  def random_path
    uuid = SecureRandom.uuid
    File.join(BASE_PATH, uuid[0..1], uuid[2..3], uuid)
  end

  def delete_file
    FileUtils.rm_f path
  end
end
