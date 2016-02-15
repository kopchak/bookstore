FactoryGirl.define do
  factory :order do
    credit_card
    delivery
    total_price { Faker::Commerce.price }
    completed_date { Faker::Date.forward(10) }
    # state 'in_queue'
  end
end