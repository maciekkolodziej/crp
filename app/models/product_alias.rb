class ProductAlias < ActiveRecord::Base
  belongs_to :product
  validates :alias, presence: true, uniqueness: true
end
