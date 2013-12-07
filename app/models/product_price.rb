class ProductPrice < ActiveRecord::Base
  belongs_to :product, autosave: true
  belongs_to :store, autosave: true
  
  validates :store_id, presence: true, uniqueness: { scope: :product_id }
  validates :product_id, presence: true, uniqueness: { scope: :store_id }
  validates :sale_price, presence: true, numericality: true
  
end
