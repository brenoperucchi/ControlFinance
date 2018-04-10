   class Unit < ApplicationRecord

  store :information, accessors:[:name, :garage, :deadline, :location]

  attr_reader :unit_value

  scope :pending, ->{ where(state: 'pending') }
  scope :booked,  ->{ where(state: 'booked') }
  scope :bought,  ->{ where(state: 'bought') }
  scope :pending_or_booked,  ->{ where(state: ['booked', 'pending']) }

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

  def proposal_bought?
    proposals.bought.present? ? true : false
  end

  ## TODO COLOCAR EM TODOS
  def proposal_bought
    proposals.try(:bought).try(:last)
  end

end