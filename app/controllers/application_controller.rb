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
    begin
      @order ||= Order.find(cookies[:order_id])
    rescue
      @order = nil
    end
  end

  private
  def current_ability
    @current_ability ||= Ability.new(current_user, current_order)
  end

  helper_method :current_user
end
