class Store < ActiveRecord::Base
  validates :symbol, presence: true, length: { maximum: 3 }
  validates :name, presence: true
  
  has_many :users, foreign_key: :current_store_id, dependent: :nullify
  
  has_many :employees, class_name: :UserRole, foreign_key: :store_id, dependent: :destroy
  accepts_nested_attributes_for :employees, allow_destroy: true, :reject_if => :all_blank
end
