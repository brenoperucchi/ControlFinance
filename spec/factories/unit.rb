FactoryBot.define do
  factory :unit, class: Unit do
    sequence :name do |n| 
      "10#{n}"
    end
    state { 'pending' }

    # before(:stub, :create) do |unit|
    #   unit.builder = create(:builder)
    # end

  end
end
