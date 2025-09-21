class TracksController < ApplicationController
  before_action :set_track, only: %i[show update destroy audio download merge]

  has_scope :by_filter, as: 'filter'
  has_scope :by_album, as: 'album_id'
  has_scope :by_artist, as: 'artist_id'
  has_scope :by_genre, as: 'genre_id'

  def index
    authorize Track
    scoped_tracks = apply_scopes(policy_scope(Track)).includes(:track_artists, :genres, audio_file: %i[location codec])
    @tracks = scoped_tracks.paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@tracks)

    render json: @tracks.map { transform_track_for_json(it) } if stale?(scope: scoped_tracks)
  end

  def show
    render json: transform_track_for_json(@track)
  end

  def create
    authorize Track
    @track = Track.new(transformed_attributes)

    if @track.save
      render json: transform_track_for_json(@track), status: :created
    else
      render json: @track.errors, status: :unprocessable_content
    end
  end

  def update
    if @track.update(transformed_attributes)
      render json: transform_track_for_json(@track), status: :ok
    else
      render json: @track.errors, status: :unprocessable_content
    end
  end

  def destroy
    render json: @track.errors, status: :unprocessable_content unless @track.destroy
  end

  def destroy_empty
    authorize Track
    Track.where(audio_file: nil).destroy_all
  end

  def audio
    conversion = CodecConversion.find_by(id: params[:codec_conversion_id])
    audio_file = @track.audio_file
    raise ActiveRecord::RecordNotFound.new('track has no audio', 'audio') unless audio_file.present? && audio_file.check_self
    raise ActiveRecord::RecordNotFound.new('codec_conversion does not exist', 'codec_conversion') if conversion.nil? && params[:codec_conversion_id].present?

    if conversion.present?
      transcoded_item = TranscodedItem.find_by(audio_file:, codec_conversion: conversion)
      unless transcoded_item.present? && File.exist?(transcoded_item.path)
        transcoded_item.destroy! if transcoded_item.present? # The file was lost. This shouldn't happen, so delete the item

        # This does the conversion inline
        CreateTranscodedItemJob.perform_now(audio_file, conversion)
        transcoded_item = TranscodedItem.find_by(audio_file:, codec_conversion: conversion)
      end
      send_file_with_range(transcoded_item.path, transcoded_item.mimetype)
    else
      send_file_with_range(audio_file.full_path, audio_file.codec.mimetype)
    end
  end

  def download
    audio_file = @track.audio_file
    raise ActiveRecord::RecordNotFound.new('track has no audio', 'audio') unless audio_file.present? && audio_file.check_self

    send_file audio_file.full_path
  end

  def merge
    @track.merge(Track.find(params[:source_id]))
    # We don't do error handling here. The merge action isn't supposed to fail.
    render json: transform_track_for_json(@track), status: :ok
  end

  private

  def send_file_with_range(path, mimetype)
    Rack::Files.new(nil).serving(request, path).tap do |(status, headers, body)|
      self.status = status
      self.response_body = body
      headers.each do |name, value|
        response.headers[name] = value
      end
      response.headers['accept-ranges'] = 'bytes'
      response.headers['content-type'] = mimetype
    end
  end

  def set_track
    @track = Track.find(params[:id])
    authorize @track
  end

  def transformed_attributes
    attributes = permitted_attributes(@track || Track)

    if attributes[:track_artists].present?
      attributes[:track_artists] = attributes[:track_artists].map do |ta|
        TrackArtist.new(artist_id: ta[:artist_id], name: ta[:name], role: ta[:role], order: ta[:order] || 0, hidden: ta[:hidden] || false)
      end
    end

    attributes
  end

  def transform_track_for_json(track)
    if current_user.moderator?
      transform_track_for_json_for_moderator(track)
    else
      transform_track_for_json_for_user(track)
    end
  end

  def transform_track_for_json_for_user(track)
    result = %i[id title normalized_title number album_id review_comment created_at updated_at genre_ids audio_file_id].index_with { track.send(it) }
    %i[codec_id length bitrate location_id].each do |attr|
      result[attr] = send(attr, track)
    end
    result[:track_artists] = track.track_artists.map { transform_track_artist_for_json(it) }
    result
  end

  def transform_track_artist_for_json(track_artist)
    %i[artist_id name normalized_name role order hidden].index_with { track_artist.send(it) }
  end

  def transform_track_for_json_for_moderator(track)
    result = transform_track_for_json_for_user(track)
    %i[filename sample_rate bit_depth].each do |attr|
      result[attr] = send(attr, track)
    end
    result
  end

  def codec_id(track)
    track.audio_file&.codec_id
  end

  def length(track)
    track.audio_file&.length
  end

  def bitrate(track)
    track.audio_file&.bitrate
  end

  def location_id(track)
    track.audio_file&.location_id
  end

  def filename(track)
    track.audio_file&.filename
  end

  def sample_rate(track)
    track.audio_file&.sample_rate
  end

  def bit_depth(track)
    track.audio_file&.bit_depth
  end
end
