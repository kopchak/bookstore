FactoryGirl.define do
  factory :delivery do
    price { Faker::Commerce.price }
    title { Faker::Name.title }
  end
end
