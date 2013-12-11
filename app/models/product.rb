class Product < ActiveRecord::Base
  stampable
  has_paper_trail
  
  # Relations
  belongs_to :unit
  belongs_to :category, class_name: :ProductCategory
  belongs_to :vat_rate
  has_many :product_prices
  has_many :product_aliases
  
  # Validations
  validates :name, presence: true, uniqueness: true, length: { maximum: 45 }
  validates :unit_id, presence: true
  
  validates :cost_price, presence: true, numericality: true, if: :purchasable?
  
  validates :register_name, presence: true, uniqueness: {scope: :active}, if: :sellable?
  validates :register_code, presence: true, uniqueness: {scope: :active}, if: :sellable?
  validates :vat_rate_id, presence: true, if: :sellable?
  validates :category_id, presence: true, if: :sellable?
  
  # Scopes
  default_scope { order('name') }
  scope :active, -> {where(active: true)}
  scope :sellable, -> {where(sellable: true)}
  scope :purchasable, -> {where(purchasable: true)}
  scope :inventoried, -> {where(inventoried: true)}
  
  # Callbacks
  before_save :clear
  
  private
  def clear
    if !self.purchasable?
      self.attributes = {cost_price: nil, inventoried: false}
    end
    if !self.sellable?
      self.attributes = {register_code: nil, register_name: nil, vat_rate_id: nil, category_id: nil}
    end
    return true
  end
end