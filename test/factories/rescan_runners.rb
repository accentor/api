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
FactoryBot.define do
  factory :rescan_runner do
    finished_at { 1.minute.ago }
    location
  end
end
