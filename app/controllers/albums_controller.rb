class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :destroy]

  has_scope :by_label, as: 'label'
  has_scope :by_labels, as: 'labels', type: :array
  has_scope :by_artist, as: 'artist_id'

  def index
    authorize Album
    unsorted_albums = apply_scopes(policy_scope(Album))
      .includes(:album_artists, :album_labels, image: [:image_attachment, :image_blob, :image_type])
    sort_direction = %w(asc desc).include?(params[:sort_direction]) ? params[:sort_direction].to_sym : nil
    sorted_albums = case params[:sort_key]
                    when "title"
                      unsorted_albums
                        .order(normalized_title: sort_direction || :asc)
                        .order(id: :asc)
                    when "added"
                      unsorted_albums
                        .order(created_at: sort_direction || :desc)
                        .order(id: :asc)
                    when "released"
                      unsorted_albums
                        .order(release: sort_direction || :desc)
                        .order(id: :asc)
                    else
                      unsorted_albums.order(id: sort_direction || :asc)
                    end
    @albums = sorted_albums.paginate(page: params[:page], per_page: params[:per_page])
    set_pagination_headers(@albums)
  end

  def show
  end

  def create
    authorize Album
    @album = Album.new(transformed_attributes)

    if @album.save
      render :show, status: :created
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  def update
    if @album.update(transformed_attributes)
      render :show, status: :ok
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  def destroy
    unless @album.destroy
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  def destroy_empty
    authorize Album
    Album.where.not(id: Track.select(:album_id).distinct).destroy_all
  end

  private

  def set_album
    @album = Album.find(params[:id])
    authorize @album
  end

  def transformed_attributes
    attributes = permitted_attributes(@album || Album)

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

    if attributes[:album_labels].present?
      attributes[:album_labels] = attributes[:album_labels].map do |al|
        AlbumLabel.new(label_id: al[:label_id], catalogue_number: al[:catalogue_number])
      end
    end

    if attributes[:album_artists].present?
      attributes[:album_artists] = attributes[:album_artists].map do |aa, i|
        AlbumArtist.new(artist_id: aa[:artist_id], name: aa[:name], separator: aa[:separator], order: aa[:order] || 0)
      end
    end

    attributes
  end
end
