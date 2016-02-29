class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_location

  def store_location
    return unless request.get? 
    if (request.path != "/customers/sign_in" &&
        request.path != "/customers/sign_up" &&
        request.path != "/customers/sign_out" &&
        !request.xhr?)
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    if customer_signed_in?
      redirect_to main_app.root_path
    else
      redirect_to new_customer_session_path
    end
  end

  def current_user
    current_customer
  end

  def current_order
    @order ||= Order.find(cookies[:order_id])
  end

  def check_order_id
    unless cookies[:order_id]
      cookies[:order_id] = Order.create.id
    end
  end

  def check_current_user
    if current_user
      current_user.orders << current_order
    end
  end

  def get_order_info
    @order_items_count = current_order.items_quantity
    @order_items_price = current_order.items_price
  end

  private
  def current_ability
    @current_ability ||= Ability.new(current_user, current_order)
  end

  helper_method :current_user
end
