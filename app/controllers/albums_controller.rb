class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :destroy]

  has_scope :by_label, as: 'label'
  has_scope :by_labels, as: 'labels', type: :array

  def index
    authorize Album
    @albums = apply_scopes(policy_scope(Album))
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
    @album.destroy
  end

  private

  def set_album
    @album = Album.find(params[:id])
    authorize @album
  end

  def transformed_attributes
    attributes = permitted_attributes(@album || Album)

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

    if attributes[:album_labels].present?
      attributes[:album_labels] = attributes[:album_labels].map do |al|
        AlbumLabel.new(label_id: al[:label_id], catalogue_number: al[:catalogue_number])
      end
    end

    attributes
  end
end
