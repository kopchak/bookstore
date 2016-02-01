class Address < ActiveRecord::Base
  has_many :billing_addresses, class_name: "Customer", foreign_key: 'billing_address_id'
  has_many :shipping_addresses, class_name: "Customer", foreign_key: 'shipping_address_id'

  validates :firstname, :lastname, :street_address, :city, :country, :zipcode, :phone, presence: true
end
