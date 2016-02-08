class CreditCard < ActiveRecord::Base
  has_many   :orders
  
  validates :number, :expiration_month, :expiration_year, :cvv, presence: true, on: :update
end
