FactoryGirl.define do
  factory :order_item do
    price { Faker::Commerce.price }
    quantity { Faker::Number.between(1, 5) }
  end
end