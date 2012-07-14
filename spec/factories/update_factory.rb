FactoryGirl.define do
  factory :update do
    title "Yup it is a storm"
    body "Several inches of rain an hour and high winds"
    author { FactoryGirl.create(:user) }
    activation

    after(:build) do |update, evaluator|
      update.instance_variable_set(:@cheating, true)
      update.save
    end
  end
end
