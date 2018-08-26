FactoryBot.define do
  factory :build do
    name { "Builder name" }
    state { 'active' }

    # after(:create) do |build|
    #   FactoryBot.create :unit, build_id: build.id
    # end
  end
end
