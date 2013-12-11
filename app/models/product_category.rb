class ProductCategory < ActiveRecord::Base
  validates :symbol, presence: true, numericality: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 45 }
  
  default_scope { order('symbol ASC') }
  
  has_many :products, dependent: :restrict_with_error, foreign_key: :category_id
end
