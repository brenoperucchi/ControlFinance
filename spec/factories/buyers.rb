FactoryGirl.define do
  factory :buyer do
    name 'Buyer Name'
    irs_id 'Buyer Irs Id'
    national_id 'Buyer National Id'
    birthdate 'Buyer birthdate'
    occupation 'Buyer ocuppation'
    base_salary 'Base Salary'

    # trait :analyze do
    #   email 'analyze'
    # end
    
  end
end
