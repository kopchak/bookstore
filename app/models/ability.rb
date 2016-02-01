class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Customer.new

    if user.id && user.admin?
      can :access, :rails_admin
      can :manage, :all
    elsif user.id
      can :read, :all
      can :manage, Rating
      can :manage, Address
      can :manage, CreditCard
      can :manage, Delivery
      can :manage, Order
      can :manage, OrderItem

    end

    unless user.id
      can :read, Book
      can :read, OrderItem
      can :read, Category
      can :read, Rating
    end

    # if user.email == "qwerty@i.ua"
    #   can :manage, :all
    # end

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
