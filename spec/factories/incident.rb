FactoryGirl.define do
  factory :incident do
    sequence(:id)
    victims []
    reported_by nil

    after(:remote) do |incident, evaluator|
      if incident.reported_by
        FactoryGirl.remote(:user, id: incident.reported_by, full_name: 'Reporter Name')
      end
    end
  end
end
