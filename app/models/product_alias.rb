class ProductAlias < ActiveRecord::Base
  belongs_to :product
  validates :alias, presence: true, uniqueness: true
  
  after_save :assign_sale_items
  
  def assign_sale_items
    SaleItem::assign_product_by_alias(self)
  end
end
