FactoryGirl.define do
  factory :broker do
    store nil
    active true
    person_type 'person'
    department 'broker'

    trait :default do
      name "Broker 1"
      before(:create) do |broker|
        broker.user = create(:user, :default)
      end
    end
    trait :second do
      name "Broker 2"
      before(:create) do |broker|
        broker.user = create(:user, :second)
      end
    end

  end
end