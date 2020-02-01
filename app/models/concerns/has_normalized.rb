module HasNormalized
  extend ActiveSupport::Concern
  include ActiveModel::Dirty

  class_methods do
    def normalized_col_generator(col_name)
      col = col_name.to_sym
      normalized_col = "normalized_#{col_name}".to_sym
      generate_normalized_col = "generate_normalized_#{col_name}".to_sym
      col_changed = "#{col_name}_changed?".to_sym

      set_callback :validation, :before, generate_normalized_col, if: col_changed

      validates normalized_col, presence: true

      define_method generate_normalized_col do
        self[normalized_col] = self.class.normalize(self[col])
      end
    end
  end
end
