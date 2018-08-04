FactoryGirl.define do
  factory :broker do
    active true
    state 'approved'
    person_type 'person'
    department 'broker'
    option1 '1'
    option2 '1'
    option3 '1'
    option4 '1'
    option5 '1'
    option6 '1'

    trait :default do
      name "Broker 1"
      irs_id '1'
      before(:create) do |broker|
        broker.user = create(:user, :default, store: broker.store)
      end
    end
    trait :second do
      name "Broker 2"
      irs_id '2'
      before(:create) do |broker|
        broker.user = create(:user, :second, store: broker.store)
      end
    end

  end
end