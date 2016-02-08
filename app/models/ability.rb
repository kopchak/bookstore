class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Customer.new

    if user.admin
      can :manage, :all
    end

    if user.id
      can [:index, :show], Book
      can :show, Category
      can :index, Delivery
      can :manage, CreditCard, customer_id: user.id
      can :manage, Order, customer_id: user.id
      can [:edit, :update], Customer, id: user.id
      can :manage, OrderItem
      can :read, Rating, check: true
      can :create, Rating

      can [:edit, :update], Address do |a|
        a.try(:user) == user
      end
    end

    unless user.id
      can [:index, :show], Book
      can :show, Category
      can :manage, OrderItem
      can :add_discount, Order
      can :read, Rating, check: true
    end

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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
