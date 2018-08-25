FactoryGirl.define do
  factory :proposal do
    negociate "Negociate"
    value 100.00
    comment nil
    due_at Date.today

    trait :analyze do
      email 'analyze'
    end
  end
end