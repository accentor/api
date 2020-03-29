class RescanRunnerSerializer < ActiveModel::Serializer
  attributes :error_text, :warning_text, :processed, :running, :finished_at
end
