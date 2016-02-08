class DeliveriesController < ApplicationController
  before_action :get_order_info, only: :index
  after_action :check_address, only: :index
  load_and_authorize_resource
  
  def index
    @ups_ground_price = Delivery.first.price
  end

  private
  def check_address
    unless current_user.billing_address.firstname
      redirect_to :back
    end
  end
end
