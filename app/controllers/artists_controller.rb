class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :update, :destroy]

  def index
    authorize Artist
    @artists = apply_scopes(policy_scope(Artist))
                   .includes(image: [:image_attachment, :image_blob, :image_type])
                   .order(id: :asc)
                   .paginate(page: params[:page])
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
      image_type = ImageType.find_by(extension: File.extname(attributes[:image][:filename]).downcase) ||
          ImageType.new(extension: File.extname(attributes[:image][:filename]).downcase,
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
