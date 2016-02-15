class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_location

  def store_location
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/customers/
  end

  def after_sign_in_path_for(user)
    session[:previous_url] || root_path
  end

  def after_sign_out_path_for(user)
    request.referrer
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

  def get_order_id
    @order = Order.find(cookies[:order_id])
  end

  def check_order_id
    unless cookies[:order_id]
      cookies[:order_id] = Order.create.id
    end
  end

  def check_current_user
    if current_user
      get_order_id
      current_user.orders << @order
    end
  end

  def get_order_info
    get_order_id
    @order_items_count = @order.order_items.count
    @order_items_price = @order.order_items.sum(:price)
  end

  helper_method :current_user
end
