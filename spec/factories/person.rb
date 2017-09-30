FactoryGirl.define do
  factory :person do
    trait :admin do
      name 'admin name'
      person_type 'person'
      department 'admin'
      active true

    end    
  end
end
