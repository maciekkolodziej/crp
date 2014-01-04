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
    current_user ||= User.new
    can :do_reset, DatabaseReset
    
    if current_user.has_role?('Admin')
      can :manage, :all
      cannot :manage, DatabaseReset
      can :do_reset, DatabaseReset
      # Comment following line if you want to mess with Roles
      cannot [:update, :destroy], Role
    elsif current_user.has_role?('Manager') 
      can [:create, :read], Sale, store_id: current_user.current_store_id
      can [:manage], Taking, store_id: current_user.current_store_id
      can [:read, :create], Product
      can [:manage], ProductPrice, store_id: current_user.current_store_id
      can [:read], Store, id: current_user.current_store_id
    elsif current_user.has_role?('Barista')
      can :create, Taking, store_id: current_user.current_store_id
    end
    
    if current_user.email == "maciek@kolodziej.com.pl"
      can :manage, DatabaseReset
    end

  end
end
