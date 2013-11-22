class Unit < ActiveRecord::Base
  validates :symbol, presence: true
  validates :name, presence: true
end
