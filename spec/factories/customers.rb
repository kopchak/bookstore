FactoryGirl.define do
  factory :customer do
    email    { Faker::Internet.email }
    password { Faker::Internet.password(8) }
  end
end