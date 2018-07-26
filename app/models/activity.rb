class Activity < ApplicationRecord

  serialize :parameters, Hash
  
  belongs_to :recipent, polymorphic: true
  belongs_to :trackable, polymorphic: true
  belongs_to :owner, polymorphic: true
end