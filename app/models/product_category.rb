class ProductCategory < ActiveRecord::Base
  validates :symbol, presence: true, numericality: true
  validates :name, presence: true, length: { maximum: 45 }
  
  default_scope order('symbol ASC')
end
