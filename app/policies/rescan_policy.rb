# == Schema Information
#
# Table name: rescan_runners
#
#  id           :bigint           not null, primary key
#  error_text   :text
#  finished_at  :datetime         not null
#  processed    :integer          default("0"), not null
#  running      :boolean          default("false"), not null
#  warning_text :text
#

class RescanPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user&.moderator?
  end

  def start?
    user&.moderator?
  end
end
