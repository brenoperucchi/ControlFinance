FactoryGirl.define do
  factory :build do
    name "Builder name"
    state 'active'

    # after(:create) do |build|
    #   FactoryGirl.create :unit, build_id: build.id
    # end
  end
end