FactoryGirl.define do
  factory :order do
    completed_date { Faker::Date.forward(10) }
  end
end