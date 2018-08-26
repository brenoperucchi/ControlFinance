FactoryBot.define do
  factory :user do
    sequence :email do |n| 
      "email-#{n}@test.com"
    end
  end

  trait :default do
    email { 'user1@test.com' }
  end
  trait :second do
    email { 'user2@test.com' }
  end

  trait :admin do
    email { 'admin@test.com' }
  end
end
