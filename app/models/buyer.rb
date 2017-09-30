class Buyer < ApplicationRecord

  store :information, accessors:[:name, :irs_id, :national_id, :birthdate, :occupation, :base_salary, :address]

  belongs_to :proposal, optional:true
end