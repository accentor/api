module HasImage
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Dirty

    after_update :destroy_replaced_image

    def destroy_replaced_image
      Image.find(image_id_previous_change[0]).destroy if image_id_previously_changed? && image_id_previous_change[0].present?
    end
  end
end
