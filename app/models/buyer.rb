class Buyer < ApplicationRecord

  store :information, accessors:[:name, :irs_id, :national_id, :birthdate, :occupation, :income, :address,:email]

  belongs_to :proposal, optional:true

  validates_presence_of :name, :irs_id, :national_id, :birthdate, :occupation, :income, :address, :email, if: -> { self.proposal.is_validate }
end