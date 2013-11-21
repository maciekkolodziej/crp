class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :store
  
  validates :role_id, presence: true
  validates :user_id, presence: true
  validates :store_id, presence: true, if: [:role_id?, "!role.global?"]
  
  after_validation :remove_store_if_global_role
  
  def remove_store_if_global_role
    if self.role.global
      self.store_id = nil
    end
  end
end
