class TracksController < ApplicationController
  include ActionController::Live

  before_action :set_track, only: %i[show update destroy audio merge]

  has_scope :by_filter, as: 'filter'
  has_scope :by_album, as: 'album_id'
  has_scope :by_artist, as: 'artist_id'
  has_scope :by_genre, as: 'genre_id'

  def index
    authorize Track
    @tracks = apply_scopes(policy_scope(Track))
              .includes(:track_artists, :genres, audio_file: %i[location codec])
              .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@tracks)

    render json: @tracks, each_serializer: serializer
  end

  def show
    render json: @track, serializer:
  end

  def create
    authorize Track
    @track = Track.new(transformed_attributes)

    if @track.save
      render json: @track, serializer: serializer, status: :created
    else
      render json: @track.errors, status: :unprocessable_entity
    end
  end

  def update
    if @track.update(transformed_attributes)
      render json: @track, serializer: serializer, status: :ok
    else
      render json: @track.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @track.errors, status: :unprocessable_entity unless @track.destroy
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
      item = TranscodedItem.find_by(audio_file:, codec_conversion: conversion)
      if item.present? && File.exist?(item.path)
        item.update(last_used: Time.current)
        audio_with_file(item.path, item.codec_conversion.resulting_codec.mimetype)
      else
        if item.present?
          # Maybe the file was lost, maybe the transcode just hadn't finished
          # yet. Anyway, doing the transcode again doesn't really hurt.
          item.do_delayed_conversion
        else
          TranscodedItem.create(audio_file:, codec_conversion: conversion)
        end
        # AudioFile will only do the conversion if the `ContentLength` doesn't exist yet.
        content_length = audio_file.calc_audio_length(conversion)
        audio_with_stream(audio_file.convert(conversion), conversion.resulting_codec.mimetype, content_length.length)
      end
    else
      audio_with_file(audio_file.full_path, audio_file.codec.mimetype)
    end
  end

  def merge
    @track.merge(Track.find(params[:source_id]))
    # We don't do error handling here. The merge action isn't supposed to fail.
    render json: @track, status: :ok
  end

  private

  def audio_with_file(path, mimetype)
    file = File.open(path, 'rb')
    audio_with_stream(file, mimetype, file.size)
  end

  def audio_with_stream(stream, mimetype, total_size)
    first_byte = 0
    last_byte = total_size - 1
    if request.headers['range'].present?
      response.status = 206
      # This is technically not a correct parsing of the header; a user agent
      # can request multiple byte ranges. In practice this doesn't happen
      # (especially not for web audio).
      match = request.headers['range'].match(/bytes=(\d+)-(\d*)/)
      first_byte = match[1].to_i
      last_byte = match[2].to_i if match[2].present?
      response.headers['content-range'] = "bytes #{first_byte}-#{last_byte}/#{total_size}"
    else
      response.status = 200
    end
    response.content_type = mimetype
    response.headers['accept-ranges'] = 'bytes'
    response.headers['content-length'] = (last_byte - first_byte + 1).to_s

    to_skip = first_byte
    while to_skip.positive?
      read_bytes = stream.read([to_skip, 16.kilobytes].min)
      to_skip -= read_bytes.length
    end
    to_send = last_byte - first_byte + 1
    while to_send.positive?
      read_bytes = stream.read([to_send, 16.kilobytes].min)
      to_send -= read_bytes.length
      response.stream.write read_bytes
    end
  ensure
    stream.close
    response.stream.close
  end

  def serializer
    current_user.moderator? ? TrackModeratorSerializer : TrackSerializer
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
end
