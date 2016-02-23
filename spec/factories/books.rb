FactoryGirl.define do
  factory :book do
    author
    title { Faker::Name.title }
    price { Faker::Commerce.price }
    stock_qty { Faker::Number.between(1, 5) }
    description { Faker::Lorem.paragraph(10) }
  end
end