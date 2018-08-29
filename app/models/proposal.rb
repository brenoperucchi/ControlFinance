class Proposal < ApplicationRecord
  # include PublicActivity::Model
  attr_accessor :comment, :is_validate, :admin_id
  
  store :information, accessors:[:name, :negociate, :value, :brokerage]

  STATUS = {pending: 'pending', booked:'book', refused:'refuse', accepted:'accept', closed:'close'}

  before_create :set_defaults
  after_create :create_documents
  after_create :mailer_created
  after_create :update_notes

  scope :not_refuse, ->{ where.not(state: 'refuse') }
  scope :opened,     ->{ where.not(state: 'closed') }
  scope :bought,     ->{ where(state: ['accepted', 'closed']) }
  scope :accepted,   ->{ where(state: 'accepted') }
  scope :book,       ->{ where(state: 'booked') }
  scope :booked,     ->{ where(state: [ 'booked', 'accepted']) }
  scope :expired,    ->{ where(state: 'refused').where.not(:due_at => nil).where("proposals.due_at < ?", Date.today) }


  scope :expire_today, ->{ where(state:'booked').where.not(state: ['accepted','closed','refused']).where(due_at: Date.today.all_day)}
  scope :expire_day3,  ->{ where(state:'booked').where.not(state: ['accepted','closed','refused']).where(due_at: Date.today + 1..Date.today + 4).where(due_at: Date.today + 4)}
  scope :expire_to_refuse,    ->{ where(state:'booked').where.not(state: ['accepted','closed','refused']).where('due_at < ?', Date.today) }
  scope :expire_to,    ->{ where(state:'booked').where.not(state: ['accepted','closed','refused']).where('due_at > ?', Date.today) }
  ## TODO 
  # CREATE NEW SPEC TEST



  #   tracked :owner      =>  proc {|controller, model| User.current.userable},
  #           :recipient  =>  proc {|controller, model| model.unit},
  #           :params => {:comment => proc {|contronller, model| model.comment}}
  # # :on => {:update => proc {|model, controller| !model.comment.blank? }}
  # has_many :activitys,   class_name: 'Activity',   as: :trackable, dependent: :destroy

  ## MENTORIA NOTES
  has_many :notes,       class_name: 'Note',       dependent: :destroy
  has_many :mailers,     class_name: 'Mailer',     as: :mailable, dependent: :destroy
  has_many :buyers,      class_name: 'Buyer',      dependent: :destroy 
  has_many :assets,      class_name: "Asset",      as: :assetable, dependent: :destroy
  has_many :documents,   class_name: "Document",   as: :documentable, dependent: :destroy
  belongs_to :unit,   optional: true
  belongs_to :broker, optional: true
  has_one    :builder,through: :unit, source: :builder

  accepts_nested_attributes_for :buyers, allow_destroy: true  
  accepts_nested_attributes_for :documents, allow_destroy: true,reject_if: :all_blank

  # validates :due_at, inclusion: { in: (Date.today..(Date.today + 5.day)) }, if: Proc.new {self.new_record?}
  validates_presence_of :negociate, :value
  validates_numericality_of :value

  state_machine initial: :pending do    
    after_transition any  => any,                      do: :update_notes
    after_transition any  => [:pending, :refused],     do: :update_states
    after_transition any  => :booked,                  do: :update_booked_at
    after_transition any  => [:booked, :accepted],     do: :update_states
    after_transition any  => :closed,                  do: :update_states
    # after_transition [:booked, :accepted, :closed, :refused] => :pending, do: :update_to_pending
    before_transition [:accepted, :closed, :pending, :refused] => :booked,          do: :restrict_accepted_booked?
    before_transition any =>           :accepted,      do: :restrict_accepted_booked?
    before_transition any           => :closed,        do: :restrict_closed?

    event :pending do
      transition [:refused, :booked, :accepted, :closed] => :pending
    end

    event :refuse do
      transition [:pending, :booked] => :refused
    end

    event :book do
      transition [:accepted, :closed, :refused, :pending] => :booked
    end

    event :accept do 
      transition [:refused, :booked, :pending, :closed] => :accepted
    end

    event :close do
      transition [:refused, :booked, :pending, :accepted] => :closed
    end

    state all do
      def restrict_accepted_booked?(state)
        if state.from == "closed" and (state.to == "accepted" or state.to == "booked")
          self.errors.add(:states, I18n.t(:proposal_should_be_pending, scope:'errors.custom'))
          return false 
        elsif state.from == "accepted" and state.to == "booked"
          self.errors.add(:states, I18n.t(:proposal_should_be_pending, scope:'errors.custom'))
          return false 
        elsif unit.booked? and not (unit.proposal_booked.try(:id) == self.id)
          self.errors.add(:states, I18n.t(:proposal_already_booked, scope:'errors.custom'))
          return false
        elsif unit.bought?
          self.errors.add(:states, I18n.t(:proposal_already_accepted, scope:'errors.custom'))
          return false
        end
      end
    end

    state all - [:closed] do
      def restrict_closed?(state)
        if (unit.booked? or unit.bought?) and (unit.proposal_bought.try(:id) != self.id)
          self.errors.add(:states, I18n.t(:proposal_already_accepted, scope:'errors.custom'))
          return false 
        elsif not self.accepted?
          self.errors.add(:states, I18n.t(:proposal_should_be_accepted, scope:'errors.custom'))
          return false 
        end
      end
    end

    state :pending, :refused do
      def update_states(state)
        self.update_columns(booked_at: nil, accepted_at: nil)
        unit.pending
      end
    end

    state :booked do
      def update_booked_at(state)
        self.update_column(:booked_at, DateTime.now)
      end
      def update_states(state)
        unit.book
      end
    end
    
    state :accepted do
      def update_states(state)
        self.update_columns(accepted_at: DateTime.now, due_at: (Date.today + 5.day))
        mailer_proposal_accepted_delivery

        unit.book
      end
    end
    
    state :closed do
      def update_states(state)
        unit.buy
      end
    end
  end

  def update_notes
    notes.create(unit: unit, broker: broker, comment: negociate)
  end

  def mailer_proposal_accepted_delivery
    mailer = self.mailers.new(store: builder.store, userable: self.broker, type: "Mailer::ProposalAccepted")
    mailer.prepare
    mailer.delivery
    mailer.save
  end

  def restricted?
    (accepted? or closed?) ? true : false
  end  

  def self.restricted?
    self.all.restricted.present? ? true : false
  end

  def broker_proposals(unit)
    return [] if broker.nil?
    broker.proposals.where(unit:unit)
  end

  def broker_attributes=(args={})
    return if args[:user_attributes].nil?
    broker = Broker.users.where(users: {email: args[:user_attributes][:email]}).first
    if broker
      self.broker = broker
    else
      broker = build_broker(args)
      broker.active = true
      # broker.store = store
      # broker.user.store = store
      self.broker = broker
      if broker.save
        args[:user_attributes][:email]
        true
      else
        errors.add(:broker, "errors")
      end
    end
  end

  def brokerage_amount
    self.value.to_f * (100 + self.brokerage.to_f/100)
  end

  def set_defaults
    self.brokerage ||= unit.brokerage 
    self.due_at = Date.today + 5.day
  end

  def current_broker?(broker)
    self.broker == broker
  end

  private
    def mailer_created
      mailer = self.mailers.new(store: builder.store, userable: self.broker, type: "Mailer::ProposalCreate")
      mailer.prepare
      mailer.delivery
    end

    def create_documents
      %w(document1 document2 document3).each do |name|
        documents.create(name: I18n.t(name, scope:'views.document.proposal'))
      end
    end

end