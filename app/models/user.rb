class User < ActiveRecord::Base
  after_create :send_admin_mail
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  belongs_to :current_store, class_name: :Store
  
  has_many :roles, class_name: :UserRole, foreign_key: :user_id, dependent: :destroy
  accepts_nested_attributes_for :roles, allow_destroy: true, :reject_if => :all_blank
  
  has_many :stores, through: :roles
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  
  def active_for_authentication? 
    super && active? 
  end 
  
  def inactive_message 
    if !active? 
      :not_approved 
    else 
      :signed_up_but_not_approved
    end 
  end
  
  def send_admin_mail
    AdminMailer.new_user(self).deliver
  end
  
  def username
    self.email.match(/[^@]+/)
  end
  
  def full_name
    self.first_name + ' ' + self.last_name
  end
  
  def multiple_stores?
    stores_count > 1 ? true : false
  end
  
  def stores_count
    self.stores.uniq.count
  end
  
  def can_use_store?(store)
    self.stores.exists?(store) ? true : false
  end
  
  def has_role?(role_name)
    self.roles.includes(:role).where("roles.name = ? AND (roles.global = true OR store_id = ?)", role_name, self.current_store_id).present?
  end
  
end
