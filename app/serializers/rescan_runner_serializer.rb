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
class RescanRunnerSerializer < ActiveModel::Serializer
  attributes :error_text, :warning_text, :processed, :running, :finished_at
end
