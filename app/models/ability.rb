class Ability
  include CanCan::Ability

  def initialize(user, current_order = nil)
    user ||= Customer.new
    if user.admin
      can :manage, :all
    else
      if user.id
        can [:new, :create], Rating, customer_id: user.id
        can [:index, :show, :complete], Order, customer_id: user.id
        can [:edit, :update_address, :update_password, :update_email], Customer, id: user.id
      end
      can :read, Book
      can :show, Category
      can [:add_discount, :clear_cart], Order, id: current_order.id if current_order
      can :create, OrderItem
      can [:index, :update, :destroy], OrderItem, order_id: current_order.id if current_order
      can :read, Rating, check: true
    end
  end
end
