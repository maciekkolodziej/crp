class Ability
  include CanCan::Ability
  
  def initialize(current_user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    can :change_store, User
    if current_user.has_role?('Admin')
      can :manage, :all
      can :read, ProductPrice, :store_id => current_user.current_store_id
    elsif current_user.has_role?('Manager') 
      can :create, Sale, current_store: true
      can :manage, ProductPrice
    elsif current_user.has_role?('Barista')
      can :read, [:unit]
    end
    
  end
end
