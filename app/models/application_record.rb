class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.per_page = 500

  def self.normalize(str)
    str.unicode_normalize(:nfkd).gsub(/[\u0300-\u036f]/, '').downcase
  end
end
