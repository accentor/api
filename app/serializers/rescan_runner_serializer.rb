# == Schema Information
#
# Table name: rescan_runners
#
#  id           :bigint           not null, primary key
#  error_text   :text
#  finished_at  :datetime         not null
#  processed    :integer          default(0), not null
#  running      :boolean          default(FALSE), not null
#  warning_text :text
#  location_id  :bigint           not null
#
# Indexes
#
#  index_rescan_runners_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
class RescanRunnerSerializer < ActiveModel::Serializer
  attributes :id, :error_text, :warning_text, :processed, :running, :finished_at, :location_id
end
