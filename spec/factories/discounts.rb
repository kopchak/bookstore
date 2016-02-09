FactoryGirl.define do
  factory :discount do
    # code { Faker::Number.number(6) }
    amount { Faker::Number.between(5, 10) }
  end
end
