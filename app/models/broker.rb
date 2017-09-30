class Broker < ApplicationRecord
  include Lib::Personhood
  
  belongs_to :store, optional: true

  has_many :proposals, class_name: 'Proposal', :foreign_key => "broker_id"
  has_one :user, as: :userable, dependent: :destroy

  scope :users, ->{ joins(:user).where(users:{userable_type: 'Broker'}) }


  accepts_nested_attributes_for :user, allow_destroy: true  


  def restricted?
    proposals.restricted.present? ? true : false
  end

  def restricted
    proposals.try(:restricted).try(:first)
  end

end