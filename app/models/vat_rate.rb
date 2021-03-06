class VatRate < ActiveRecord::Base
  validates :symbol, presence: true, length: { maximum: 1 }
  validates :rate, presence: true, numericality: true
  
  def to_s
    symbol
  end
  
end
