class BillingAddress < Address
  has_one :customer
end