# == Schema Information
#
# Table name: playlists
#
#  id            :bigint           not null, primary key
#  access        :integer          default("shared")
#  description   :string
#  name          :string           not null
#  playlist_type :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_playlists_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Playlist < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'PlaylistItem', dependent: :destroy

  enum :access, { shared: 0, personal: 1, secret: 2 }
  enum :playlist_type, { album: 0, artist: 1, track: 2 }

  scope :with_item_ids, lambda {
    left_joins(:items)
      # We gather the item_ids using `array_agg`, but this results in `[null]` if there are no playlist_items
      # to filter these occurences out we first remove null values with `array_remove` (since `playlist_items.item_id` can never be null)
      # and the coalesce with an empty array so we always have a value to return
      .select('playlists.*', 'COALESCE(array_remove(array_agg(playlist_items.item_id ORDER BY playlist_items.order ASC), NULL), ARRAY[]::bigint[]) as item_ids')
      .group(:id)
  }

  validates :name, presence: true
  validate :item_ids_should_be_unique

  before_save :normalize_item_order

  def item_ids
    # If with_item_ids was used, we use the output from the SQL query
    return read_attribute(:item_ids) if has_attribute?(:item_ids)

    # Otherwise we check if the items are loaded and either collect the ids with ruby or with SQL
    items.loaded? ? items.sort_by(&:order).collect(&:item_id) : items.order(:order).pluck(:item_id)
  end

  def item_ids=(ids)
    # Reset the items
    self.items = []
    item_type = playlist_type.capitalize

    # Use `self.items.build` to make sure we first fully validate the playlist and items before saving
    # This makes sure that we correctly validate and return errors for double items
    ids.map.with_index(1) { |id, i| items.build(item_id: id, item_type:, order: i) }
  end

  private

  def normalize_item_order
    items.sort { |i1, i2| i1.order <=> i2.order }.map.with_index(1) do |item, index|
      item.order = index
      item.save unless item.new_record?
    end
  end

  def item_ids_should_be_unique
    # When validating, we use `collect(&:item_id)` so we get the correct data
    # Regardless of whether the items were already saved
    doubles = items.collect(&:item_id).uniq!
    errors.add(:items, 'item-ids-contains-double') unless doubles.nil?
  end
end
