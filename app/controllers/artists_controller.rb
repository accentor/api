class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :update, :destroy]

  has_scope :by_filter, as: 'filter'

  def index
    authorize Artist
    unsorted_artists = apply_scopes(policy_scope(Artist)).includes(image: [:image_attachment, :image_blob, :image_type])
    sort_direction = %w(asc desc).include?(params[:sort_direction]) ? params[:sort_direction].to_sym : nil
    sorted_artists = case params[:sort_key]
                     when "name"
                       unsorted_artists
                         .order(normalized_name: sort_direction || :asc)
                         .order(id: :asc)
                     when "added"
                       unsorted_artists
                         .order(created_at: sort_direction || :desc)
                         .order(id: :asc)
                     else
                       unsorted_artists.order(id: sort_direction || :asc)
                     end
    @artists = sorted_artists.paginate(page: params[:page], per_page: params[:per_page])
    set_pagination_headers(@artists)
  end

  def show
  end

  def create
    authorize Artist
    @artist = Artist.new(transformed_attributes)

    if @artist.save
      render :show, status: :created
    else
      render json: @artist.errors, status: :unprocessable_entity
    end
  end

  def update
    if @artist.update(transformed_attributes)
      render :show, status: :ok
    else
      render json: @artist.errors, status: :unprocessable_entity
    end
  end

  def destroy
    unless @artist.destroy
      render json: @artist.errors, status: :unprocessable_entity
    end
  end

  def destroy_empty
    authorize Artist
    Artist
        .where.not(id: TrackArtist.select(:artist_id).distinct)
        .where.not(id: AlbumArtist.select(:artist_id).distinct)
        .destroy_all
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
    authorize @artist
  end

  def transformed_attributes
    attributes = permitted_attributes(@artist || Artist)
    if attributes[:image].present?
      image_type = ImageType.find_by(extension: File.extname(attributes[:image][:filename])[1..].downcase) ||
          ImageType.new(extension: File.extname(attributes[:image][:filename])[1..].downcase,
                        mimetype: attributes[:image][:mimetype])

      image = Image.new(image_type: image_type)
      image.image.attach(io: StringIO.new(Base64.decode64(attributes[:image][:data])),
                         filename: attributes[:image][:filename],
                         content_type: attributes[:image][:mimetype])

      attributes[:image] = image
    end
    attributes
  end
end
