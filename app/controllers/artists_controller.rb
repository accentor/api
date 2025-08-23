class ArtistsController < ApplicationController
  include ImageRendering

  before_action :set_artist, only: %i[show update destroy merge]

  has_scope :by_filter, as: 'filter'

  def index
    authorize Artist
    scoped_artists = apply_scopes(policy_scope(Artist))
    @artists = scoped_artists.includes(image: [{ image_attachment: :blob }, :image_type])
                             .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@artists)

    render json: @artists.map { transform_artist_for_json(it) } if stale?(etag: scoped_artists)
  end

  def show
    render json: transform_artist_for_json(@artist)
  end

  def create
    authorize Artist
    @artist = Artist.new(transformed_attributes)

    if @artist.save
      render json: transform_artist_for_json(@artist), status: :created
    else
      render json: @artist.errors, status: :unprocessable_content
    end
  end

  def update
    if @artist.update(transformed_attributes)
      render json: transform_artist_for_json(@artist), status: :ok
    else
      render json: @artist.errors, status: :unprocessable_content
    end
  end

  def destroy
    render json: @artist.errors, status: :unprocessable_content unless @artist.destroy
  end

  def destroy_empty
    authorize Artist
    Artist
      .where.not(id: TrackArtist.select(:artist_id).distinct)
      .where.not(id: AlbumArtist.select(:artist_id).distinct)
      .destroy_all
  end

  def merge
    render json: @artist.errors, status: :unprocessable_content unless @artist.merge(Artist.find(params[:source_id]))
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
    authorize @artist
  end

  def transformed_attributes
    attributes = permitted_attributes(@artist || Artist)
    if attributes[:image].present? && attributes[:image][:data].nil?
      attributes[:image] = nil
    elsif attributes[:image].present?
      image_type = ImageType.find_by(extension: File.extname(attributes[:image][:filename])[1..].downcase) ||
                   ImageType.new(extension: File.extname(attributes[:image][:filename])[1..].downcase,
                                 mimetype: attributes[:image][:mimetype])

      image = Image.new(image_type:)
      image.image.attach(io: StringIO.new(Base64.decode64(attributes[:image][:data])),
                         filename: attributes[:image][:filename],
                         content_type: attributes[:image][:mimetype])

      attributes[:image] = image
    end
    attributes
  end

  def transform_artist_for_json(artist)
    result = %i[id name normalized_name review_comment created_at updated_at].index_with { artist.send(it) }
    %i[image image100 image250 image500 image_type].each do |attr|
      result[attr] = send(attr, artist)
    end
    result
  end
end
