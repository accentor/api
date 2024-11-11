module ImageRendering
  extend ActiveSupport::Concern

  included do
    private

    def image(object)
      return nil if object.image.blank?
      return nil unless object.image.image.variable?

      rails_blob_url(object.image.image)
    end

    def image100(object)
      return nil if object.image.blank?
      return nil unless object.image.image.variable?

      rails_representation_url(object.image.image.variant(resize_to_cover: [100, 100]))
    end

    def image250(object)
      return nil if object.image.blank?
      return nil unless object.image.image.variable?

      rails_representation_url(object.image.image.variant(resize_to_cover: [250, 250]))
    end

    def image500(object)
      return nil if object.image.blank?
      return nil unless object.image.image.variable?

      rails_representation_url(object.image.image.variant(resize_to_cover: [500, 500]))
    end

    def image_type(object)
      return nil if object.image.blank?
      return nil unless object.image.image.variable?

      object.image.image_type.mimetype
    end
  end
end
