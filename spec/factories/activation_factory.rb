FactoryGirl.define do
  factory :activation do
    title { Faker::Company.catch_phrase }
  end
end
