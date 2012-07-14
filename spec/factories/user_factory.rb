FactoryGirl.define do
  factory :user do
    first_name Faker::Name.first_name
    last_name  Faker::Name.last_name
    password 'foobarbaz'
    password_confirmation 'foobarbaz'

    after(:create) do |user, evaluator|
      user.authorize_with(user).add_email("#{evaluator.first_name}.#{evaluator.last_name}@example.com")
      user.primary_email.activate
    end
  end
end
