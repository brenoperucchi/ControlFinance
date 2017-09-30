FactoryGirl.define do
  factory :proposal do
    negociate "Negociate"
    value 'pending'
    comment nil
    due_at DateTime.now

    trait :analyze do
      email 'analyze'
    end
  end
end