class PlaysController < ApplicationController
  has_scope :by_album, as: 'album_id'
  has_scope :by_artist, as: 'artist_id'
  has_scope :played_before, as: 'played_before'
  has_scope :played_after, as: 'played_after'

  def index
    authorize Play
    @plays = apply_scopes(policy_scope(Play))
             .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@plays)

    render json: @plays.map { transform_play_for_json(it) }
  end

  def create
    authorize Play
    @play = Play.new(transformed_attributes)

    if @play.save
      render json: transform_play_for_json(@play), status: :created
    else
      render json: @play.errors, status: :unprocessable_content
    end
  end

  def stats
    authorize Play
    @stats = apply_scopes(policy_scope(Play))
             .left_joins(track: :audio_file)
             .select('COUNT(*)', 'MAX(played_at) as last_played_at', 'SUM(COALESCE("audio_files"."length", 0)) as total_length', :track_id, :user_id)
             .group(:track_id, :user_id)
             .order(track_id: :desc)
             .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@stats)

    render json: @stats.map { transform_play_stat_for_json(it) }
  end

  private

  def transformed_attributes
    permitted_attributes(Play).merge(user: current_user)
  end

  def transform_play_for_json(play)
    %i[id played_at track_id user_id created_at updated_at].index_with { play.send(it) }
  end

  def transform_play_stat_for_json(play_stat)
    %i[count track_id last_played_at total_length].index_with { play_stat.send(it) }
  end
end
