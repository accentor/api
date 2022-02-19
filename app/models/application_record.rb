class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  self.per_page = 500

  scope :sorted, ->(_) { order(id: :desc) }

  def self.normalize(str)
    str.unicode_normalize(:nfkd).gsub(/[\u0300-\u036f]/, '').downcase
  end
end
