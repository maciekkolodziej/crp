class Role < ActiveRecord::Base
  default_scope order('name ASC')
  scope :global,  where( { global: true } )
  scope :local,   where( { global: false } )
  
  has_many :user_roles, dependent: :destroy
end
