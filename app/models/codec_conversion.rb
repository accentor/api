# == Schema Information
#
# Table name: codec_conversions
#
#  id                 :bigint           not null, primary key
#  ffmpeg_params      :string           not null
#  name               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  resulting_codec_id :bigint           not null
#
# Indexes
#
#  index_codec_conversions_on_name                (name) UNIQUE
#  index_codec_conversions_on_resulting_codec_id  (resulting_codec_id)
#
# Foreign Keys
#
#  fk_rails_...  (resulting_codec_id => codecs.id)
#

class CodecConversion < ApplicationRecord
  belongs_to :resulting_codec, class_name: 'Codec'

  has_many :transcoded_items, dependent: :delete_all

  validates :name, presence: true, uniqueness: true
  validates :ffmpeg_params, presence: true

  scope :by_codec, ->(codec) { where(resulting_codec: codec) }

  before_destroy :delete_transcoded_item_files
  after_save :reset_transcoded_items

  delegate :mimetype, to: :resulting_codec

  def reset_transcoded_items
    transcoded_items.delete_all
    delete_transcoded_item_files
    QueueTranscodedItemsForCodecConversionJob.perform_later(self)
  end

  private

  def delete_transcoded_item_files
    FileUtils.rm_rf TranscodedItem.codec_conversion_base_path(self)
  end
end
