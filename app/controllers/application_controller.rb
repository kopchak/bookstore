class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|

    if customer_signed_in?
      # flash.now[:error] = "Not authorized to view this page"
      redirect_to main_app.root_path
    else
      # flash.now[:error] = "You must sign up to view this page"
      redirect_to new_customer_session_path
    end
  end

  def current_user
    current_customer
  end

  def check_order_id
    unless cookies[:order_id]
      order = Order.new
      order.save
      cookies[:order_id] = order.id
    end
  end

  def check_current_user
    order = Order.find(cookies[:order_id])
    if current_user
      current_user.orders << order
    end
  end

  def check_address
    unless current_user.billing_address.firstname
      redirect_to :back
    end
  end

  def create_address_if_nil
    unless current_user.billing_address && current_user.shipping_address
      bil_addr = current_user.build_billing_address
      ship_addr = current_user.build_shipping_address
      bil_addr.save(validate: false)
      ship_addr.save(validate: false)
      current_user.save
    end
  end

  def create_credit_card_if_nil
    order = Order.find(cookies[:order_id])
    unless order.credit_card
      credit_card = order.build_credit_card(customer_id: current_user.id)
      credit_card.save(validate: false)
      order.save
    end
  end

  helper_method :current_user
end
