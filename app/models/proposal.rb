class Proposal < ApplicationRecord
  include PublicActivity::Model
  attr_accessor :comment
  
  store :information, accessors:[:name, :negociate, :value, :brokerage]

  STATUS = {pending: 'pending', booked:'book', refused:'refuse', accepted:'accept', closed:'close'}

  before_create :default_brokerage
  after_create :create_documents


  scope :not_refuse, ->{ where.not(state: 'refuse') }
  scope :finished,   ->{ where(state: ['accepted', 'closed']) }
  scope :accepted,   ->{ where(state: 'accepted') }
  scope :restricted, ->{ where(state: ['accepted', 'closed']) }
  scope :expired,    ->{ where(state:'booked').where("proposals.due_at < ?", Date.today) }

  tracked :only =>[:update], 
          :owner      =>  proc {|controller, model| User.current.userable},
          :recipient  =>  proc {|controller, model| model.unit},
          :params => {
                      :comment => proc {|contronller, model| model.comment},
                     },
          :on => {
                   :update => proc {|model, controller| !model.comment.blank? }
                 }

  has_many :mailers,   class_name: 'Mailer',   as: :mailable
  has_many :buyers,    class_name: 'Buyer',    dependent: :nullify 
  has_many :assets,    class_name: "Asset",    as: :assetable, dependent: :destroy
  has_many :documents, class_name: "Document", as: :documentable, dependent: :destroy
  belongs_to :unit, optional: true
  belongs_to :broker, optional: true
  has_one :builder, through: :unit, source: :builder

  accepts_nested_attributes_for :broker, allow_destroy: true  
  accepts_nested_attributes_for :buyers, allow_destroy: true  
  accepts_nested_attributes_for :documents, allow_destroy: true,reject_if: :all_blank

  validates :due_at, inclusion: { in: (Date.today..(Date.today + 5.day)) }, if: Proc.new {self.new_record?}
  validates_presence_of :negociate

  state_machine initial: :pending do    
    after_transition any  => [:pending, :refused],     do: :update_states
    after_transition any  => :booked,                  do: :update_booked_at
    after_transition any  => [:booked, :accepted],     do: :update_states
    after_transition any  => :closed,                  do: :update_states
    after_transition [:booked, :accepted, :closed] => :pending, do: :update_to_pending
    before_transition :pending => :booked,             do: :restrict_booked?
    before_transition any - :booked => :closed,        do: :restrict_closed?
    before_transition any - :booked => :accepted,      do: :restrict_accepted?

    event :pending do
      transition [:refused, :booked, :accepted, :closed] => :pending
    end

    event :refuse do
      transition [:pending, :booked] => :refused
    end

    event :book do
      transition [:pending] => :booked
    end

    event :accept do 
      transition [:pending, :booked, :closed] => :accepted
    end

    event :close do
      transition [:booked, :accepted] => :closed
    end

    state :pending do
      def restrict_booked?(state)
        if unit.booked? or unit.bought?
          self.errors.add(:state, I18n.t(:proposal_accepted, scope:'errors.custom'))
          return false 
        end        
      end
    end

    state all - [:booked, :accepted] do
      def restrict_accepted?(state)
        if unit.booked? or unit.bought?
          self.errors.add(:state, I18n.t(:proposal_accepted, scope:'errors.custom'))
          return false
        end
      end
    end

    state all - [:booked, :closed] do
      def restrict_closed?(state)
        if unit.bought?
          self.errors.add(:state, I18n.t(:proposal_accepted, scope:'errors.custom'))
          return false 
        end
      end
    end

    state :pending, :refused do
      def update_states(state)
        self.update_columns(booked_at: nil, accepted_at: nil, due_at: nil)
      end
      def update_to_pending(state)
        unit.pending
      end
    end

    state :booked do
      def update_booked_at(state)
        self.update_column(:booked_at, DateTime.now)
      end
    end

    state :booked do
      def update_states(state)
        # unit.book
      end
    end
    
    state :accepted do
      def update_states(state)
        MailerMethod::ProposalAccepted.new(self).deliver_mail
        self.update_columns(accepted_at: DateTime.now)
        unit.book
      end
    end
    
    state :closed do
      def update_states(state)
        unit.buy
      end
    end
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

  def default_brokerage
    self.brokerage ||= unit.brokerage 
  end

  private
    def create_documents
      %w(document1 document2 document3).each do |name|
        documents.create(name: I18n.t(name, scope:'helpers.document.proposal'))
      end
    end

end