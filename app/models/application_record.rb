class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.per_page = 500

  scope :sorted, lambda { |_key, direction|
    order(id: direction || :asc)
  }

  def self.normalize(str)
    str.unicode_normalize(:nfkd).gsub(/[\u0300-\u036f]/, '').downcase
  end
end
