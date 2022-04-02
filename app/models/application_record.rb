class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  self.per_page = 500

  scope :sorted, ->(_) { order(id: :desc) }

  def self.normalize(str)
    str.unicode_normalize(:nfkd).gsub(/[\u0300-\u036f]/, '').downcase
  end

  def self.normalize_blank_values(*cols)
    cols.each do |col|
      col_changed = :"#{col}_changed?"
      method_name = :"normalize_blank_#{col}_value"

      set_callback :validation, :before, method_name, if: col_changed

      define_method method_name do
        self[col].present? || self[col] = nil
      end
    end
  end
end
