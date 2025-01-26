class AlbumsController < ApplicationController
  include ImageRendering

  before_action :set_album, only: %i[show update destroy merge]

  has_scope :by_filter, as: 'filter'
  has_scope :by_label, as: 'label'
  has_scope :by_labels, as: 'labels', type: :array
  has_scope :by_artist, as: 'artist_id'

  def index
    authorize Album
    @albums = apply_scopes(policy_scope(Album))
              .includes(:album_artists, :album_labels, image: [{ image_attachment: :blob }, :image_type])
              .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@albums)

    render json: @albums.map { transform_album_for_json(it) }
  end

  def show
    render json: transform_album_for_json(@album)
  end

  def create
    authorize Album
    @album = Album.new(transformed_attributes)

    if @album.save
      render json: transform_album_for_json(@album), status: :created
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  def update
    if @album.update(transformed_attributes)
      render json: transform_album_for_json(@album), status: :ok
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @album.errors, status: :unprocessable_entity unless @album.destroy
  end

  def destroy_empty
    authorize Album
    Album.where.not(id: Track.select(:album_id).distinct).destroy_all
  end

  def merge
    render json: @album.errors, status: :unprocessable_entity unless @album.merge(Album.find(params[:source_id]))
  end

  private

  def set_album
    @album = Album.find(params[:id])
    authorize @album
  end

  def transformed_attributes
    attributes = permitted_attributes(@album || Album)

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

    if attributes[:album_labels].present?
      attributes[:album_labels] = attributes[:album_labels].map do |al|
        AlbumLabel.new(label_id: al[:label_id], catalogue_number: al[:catalogue_number])
      end
    end

    if attributes[:album_artists].present?
      attributes[:album_artists] = attributes[:album_artists].map do |aa, _i|
        AlbumArtist.new(artist_id: aa[:artist_id], name: aa[:name], separator: aa[:separator], order: aa[:order] || 0)
      end
    end

    attributes
  end

  def transform_album_for_json(album)
    result = %i[id title normalized_title release review_comment edition edition_description created_at updated_at].index_with { album.send(it) }
    %i[image image100 image250 image500 image_type].each do |attr|
      result[attr] = send(attr, album)
    end
    result[:album_artists] = album.album_artists.map { transform_album_artist_for_json(it) }
    result[:album_labels] = album.album_labels.map { transform_album_label_for_json(it) }
    result
  end

  def transform_album_artist_for_json(album_artist)
    %i[artist_id name normalized_name order separator].index_with { |attr| album_artist.send(attr) }
  end

  def transform_album_label_for_json(album_label)
    %i[label_id catalogue_number].index_with { |attr| album_label.send(attr) }
  end
end
