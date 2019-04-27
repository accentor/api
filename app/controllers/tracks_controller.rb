class TracksController < ApplicationController
  include ActionController::Live

  before_action :set_track, only: %i[show update destroy audio merge]

  has_scope :by_album, as: 'album_id'
  has_scope :by_genre, as: 'genre_id'

  def index
    authorize Track
    @tracks = apply_scopes(policy_scope(Track)).includes(:track_artists, :genres, audio_file: [:location, :codec])
  end

  def show
  end

  def create
    authorize Track
    @track = Track.new(transformed_attributes)

    if @track.save
      render :show, status: :created
    else
      render json: @track.errors, status: :unprocessable_entity
    end
  end

  def update
    if @track.update(transformed_attributes)
      render :show, status: :ok
    else
      render json: @track.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @track.destroy
  end

  def destroy_empty
    authorize Track
    Track.where(audio_file: nil).destroy_all
  end

  def audio
    conversion = CodecConversion.find_by(id: params[:codec_conversion_id])
    audio_file = @track.audio_file
    raise ActiveRecord::RecordNotFound, 'track has no audio' unless audio_file.present? && audio_file.check_self
    raise ActiveRecord::RecordNotFound, 'codec_conversion does not exist' if conversion.nil? && params[:codec_conversion_id].present?

    if conversion.present?
      begin
        response.status = 200
        response.content_type = conversion.resulting_codec.mimetype

        stream = audio_file.convert(conversion)
        while (bytes = stream.read(16.kilobytes))
          response.stream.write bytes
        end
      ensure
        stream&.close
        response.stream.close
      end
    else
      Rack::File.new(nil).serving(request, audio_file.full_path).tap do |(status, headers, body)|
        self.status = status
        self.response_body = body

        headers.each do |name, value|
          response.headers[name] = value
        end

        response.headers['accept-ranges'] = 'bytes'
        response.headers['content-type'] = audio_file.codec.mimetype
      end
    end
  end

  def merge
    @track.merge(Track.find(params[:other_track_id]))
    render :show, status: :ok
  end

  private

  def set_track
    @track = Track.find(params[:id])
    authorize @track
  end

  def transformed_attributes
    attributes = permitted_attributes(@track || Track)

    if attributes[:track_artists].present?
      attributes[:track_artists] = attributes[:track_artists].map do |ta|
        TrackArtist.new(artist_id: ta[:artist_id], name: ta[:name], role: ta[:role], order: ta[:order] || 0)
      end
    end

    attributes
  end
end
