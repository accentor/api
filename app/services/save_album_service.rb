class SaveAlbumService
  attr_reader :album, :attributes

  def initialize(album, attributes)
    @album = album
    @attributes = attributes
  end

  def call
    album.assign_attributes(attributes.except(:image, :album_labels, :album_artists))
    album.image = image if attributes[:image].present?
    album.album_labels = album_labels if attributes[:album_labels].present?
    process_album_artists
    album.save
  end

  def self.call(*)
    new(*).call
  end

  private

  def image
    return if attributes[:image][:data].nil?

    image_type = ImageType.find_by(extension: File.extname(attributes[:image][:filename])[1..].downcase) ||
                 ImageType.new(extension: File.extname(attributes[:image][:filename])[1..].downcase,
                               mimetype: attributes[:image][:mimetype])

    image = Image.new(image_type:)
    image.image.attach(io: StringIO.new(Base64.decode64(attributes[:image][:data])),
                       filename: attributes[:image][:filename],
                       content_type: attributes[:image][:mimetype])

    image
  end

  def album_labels
    attributes[:album_labels].map do |al|
      AlbumLabel.new(label_id: al[:label_id], catalogue_number: al[:catalogue_number])
    end
  end

  def process_album_artists
    return if attributes[:album_artists].blank?

    artist_ids = attributes[:album_artists].pluck(:artist_id)
    album.album_artists.reject { artist_ids.include?(it.artist_id) }.each(&:mark_for_destruction)

    attributes[:album_artists].each do |aa|
      if (existing = album.album_artists.find { it.artist_id == aa[:artist_id] }).present?
        existing.assign_attributes(aa)
      else
        album.album_artists.build({ order: 0 }.merge(aa))
      end
    end
  end
end
