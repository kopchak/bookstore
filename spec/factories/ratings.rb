FactoryGirl.define do
  factory :rating do
    rating { Faker::Number.between(1, 5) }
    title  { Faker::Lorem.sentence }
    review { Faker::Lorem.paragraph }
  end
end