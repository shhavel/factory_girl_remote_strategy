FactoryGirl.define do
  factory :membership do
    sequence(:id)
    group_id nil

    after(:build) do |membership, evaluator|
      if !evaluator.group_id && !evaluator.respond_to?(:group)
        membership.group = FactoryGirl.remote(:group)
      end
    end
  end
end
