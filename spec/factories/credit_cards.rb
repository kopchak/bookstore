FactoryGirl.define do
  factory :credit_card do
    number { Faker::Number.number(16) }
    expiration_month { Faker::Number.between(1, 12) }
    expiration_year { Faker::Number.between(2016, 2050) }
    cvv { Faker::Number.number(3) }
  end
end