class ShippingAddress < Address
  has_one :customer
end