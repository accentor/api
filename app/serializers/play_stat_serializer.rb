class PlayStatSerializer < ActiveModel::Serializer
  attributes :count, :track_id, :last_played_at
end
