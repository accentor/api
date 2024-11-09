# == Schema Information
#
# Table name: transcoded_items
#
#  id                  :bigint           not null, primary key
#  uuid                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#
# Indexes
#
#  index_transcoded_items_on_audio_file_id                          (audio_file_id)
#  index_transcoded_items_on_audio_file_id_and_codec_conversion_id  (audio_file_id,codec_conversion_id) UNIQUE
#  index_transcoded_items_on_codec_conversion_id                    (codec_conversion_id)
#  index_transcoded_items_on_codec_conversion_id_and_uuid           (codec_conversion_id,uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (audio_file_id => audio_files.id)
#  fk_rails_...  (codec_conversion_id => codec_conversions.id)
#
class TranscodedItem < ApplicationRecord
  BASE_PATH = Rails.configuration.transcode_storage_path

  belongs_to :audio_file
  belongs_to :codec_conversion

  validates :audio_file_id, uniqueness: { scope: :codec_conversion_id }
  validates :uuid, presence: true, uniqueness: { scope: :codec_conversion_id }

  # Be careful when adding destroy callbacks! For performance reasons
  # CodecConversion#destroy/CodecConversion#update ignore these (and take care
  # of deleting the relevant files themselves).
  after_commit :delete_file, on: :destroy

  delegate :mimetype, to: :codec_conversion

  def path
    self.class.path_for(codec_conversion, uuid)
  end

  def self.uuid_for(codec_conversion)
    loop do
      uuid = SecureRandom.uuid
      return uuid unless TranscodedItem.exists?(codec_conversion:, uuid:)
    end
  end

  def self.codec_conversion_base_path(codec_conversion)
    File.join(BASE_PATH, codec_conversion.id.to_s)
  end

  def self.path_for(codec_conversion, uuid)
    File.join(codec_conversion_base_path(codec_conversion), uuid[0..1], uuid[2..3], uuid)
  end

  private

  def delete_file
    FileUtils.rm_f path
  end
end
