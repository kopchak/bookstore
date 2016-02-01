class CreditCard < ActiveRecord::Base
  belongs_to :customer
  has_many   :orders
  
  validates :number, :expiration_month, :expiration_year, :cvv, presence: true
end
