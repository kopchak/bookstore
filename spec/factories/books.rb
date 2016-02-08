FactoryGirl.define do
  factory :book do
    title { Faker::Name.title }
    price { Faker::Commerce.price }
    stock_qty { Faker::Number.between(1, 5) }
  end
end