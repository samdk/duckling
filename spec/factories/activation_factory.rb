FactoryGirl.define do
  factory :activation do
    title 'Zomg a storm'
    ignore do
      member { FactoryGirl.create(:user) }
    end

    after(:create) do |activation, evaluator|
      activation.instance_variable_set(:@cheating, true)
      activation.users << evaluator.member
      activation.save
    end

    factory :activation_with_updates do
      ignore { update_count 5 }

      after(:create) do |activation, evaluator|
        FactoryGirl.build_list(:update, evaluator.update_count, activation: activation)
      end
    end
  end
end
