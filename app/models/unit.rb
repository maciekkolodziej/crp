class Unit < ActiveRecord::Base
  validates :symbol, presence: true
  validates :name, presence: true
  
  def to_s
    self.symbol
  end
end
