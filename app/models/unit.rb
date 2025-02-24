class Unit < ApplicationRecord

  STATES = {pending: 'pending', booked:'book', bought:'buy'}

  store :information, accessors:[:name, :garage, :deadline, :registry, :incorporation, :position, :dormitory, :box, :area_privative, :area_common, :area_total, :area_value]

  attr_reader :unit_value

  scope :pending, ->{ where(state: 'pending') }
  scope :booked,  ->{ where(state: 'booked') }
  scope :bought,  ->{ where(state: 'bought') }
  scope :pending_or_booked,  ->{ where(state: ['booked', 'pending']) }

  ## TODO CREATE SOFT DELETE
  has_many :mailers,   class_name: 'Mailer', as: :mailable, dependent: :nullify 
  has_many :activities,   class_name: 'Activity', as: :recipient, dependent: :nullify 
  has_many :proposals, class_name: "Proposal", foreign_key: "unit_id", dependent: :nullify 
  has_many :admin_proposals, class_name: 'Admin::Proposal', foreign_key: "unit_id", dependent: :nullify 
  belongs_to :builder, class_name: 'Build', :foreign_key => "build_id"
  
  validates_presence_of :name
  # validates_uniqueness_of :name, scope:[:build_id]

  accepts_nested_attributes_for :proposals, :admin_proposals

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

  def activities_broker(broker)
    activities.where(owner:broker)
  end

  def proposal_bought?
    proposals.bought.present? ? true : false
  end

  ## TODO COLOCAR EM TODOS
  def proposal_booked
    proposals.try(:booked).try(:last)
  end

  def proposal_bought
    proposals.try(:bought).try(:last)
  end

  def bought_to_broker?(current_user)
    try(:proposal_bought).try(:current_broker?, (current_user.try(:userable)))
  end

end