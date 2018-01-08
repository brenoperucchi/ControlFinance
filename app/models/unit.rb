   class Unit < ApplicationRecord

  store :information, accessors:[:name, :state, :garage, :deadline]

  attr_reader :unit_value

  ## TODO CREATE SOFT DELETE
  has_many :mailers,   class_name: 'Mailer', as: :mailable
  has_many :proposals, class_name: "Proposal", foreign_key: "unit_id", dependent: :nullify 
  has_many :admin_proposals, class_name: "Admin::Proposal", foreign_key: "unit_id", dependent: :nullify 
  belongs_to :builder, class_name: 'Build', :foreign_key => "build_id"
  
  validates_presence_of :name
  # validates_uniqueness_of :name, scope:[:build_id]

  accepts_nested_attributes_for :proposals

  state_machine initial: :pending do
    # after_transition :pending => :aproved, :do => :create_ledger
    event :book do 
      transition [:pending] => :booked
    end
    event :buy do
      transition [:pending, :booked] => :bought
    end
    event :pending do
      transition [:bought, :booked] => :pending
    end
  end

  def restricted?
    proposals.restricted.present? ? true : false
  end

  def restricted
    proposals.try(:restricted).try(:first)
  end

end