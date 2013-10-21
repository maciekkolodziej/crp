class Pos < ActiveRecord::Base
  has_many :sales
  has_many :sale_items, through: :sales
  has_many :sale_receipts, through: :sales
end
