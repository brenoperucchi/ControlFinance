class Broker < ApplicationRecord
  include Lib::Personhood

  after_create :create_documents

  STATES = {pending: 'pending', refused:'refuse', accepted:'accept'}

  include PublicActivity::Model
  attr_accessor :comment
  
  tracked :only =>[:update], 
          :owner      =>  proc {|controller, model| User.current.userable},
          :recipient  =>  proc {|controller, model| model.store},
          :params => {
                      :comment => proc {|contronller, model| model.comment},
                     },
          :on => {
                   :update => proc {|model, controller| !model.comment.blank? }
                 }

  store :serializes, accessors:[:option1, :option2, :option3, :option4, :option5, :address, :phone, :company_irs_id]
  
  belongs_to :store, optional: true
  has_one :user, as: :userable, dependent: :destroy
  has_many :proposals, class_name: 'Proposal', foreign_key: "broker_id"
  has_many :assets,    class_name: "Asset",    as: :assetable, dependent: :destroy
  has_many :documents, class_name: "Document", as: :documentable, dependent: :destroy

  scope :users, ->{ joins(:user).where(users:{userable_type: 'Broker'}) }

  accepts_nested_attributes_for :user, allow_destroy: true  

  validates :option1, :option2, :option3, :option4, :option5, acceptance: { accept: '1' }, on: :create
  validates_presence_of :name, :option1, :option2, :option3, :option4, :option5, on: :create
  validates_uniqueness_of :irs_id, scope:[:store_id]

  accepts_nested_attributes_for :user

  # state_machine initial: :pending do    
    # after_transition any  => [:pending, :refused],     do: :update_states
    # after_transition any  => :booked,                  do: :update_booked_at
    # after_transition any  => [:booked, :accepted],     do: :update_states
    # after_transition any  => :closed,                  do: :update_states
    # after_transition [:booked, :accepted, :closed] => :pending, do: :update_to_pending
    # before_transition :pending => :booked,             do: :restrict_booked?
    # before_transition any - :booked => :closed,        do: :restrict_closed?
    # before_transition any - :booked => :accepted,      do: :restrict_accepted?

    # event :pending do
    #   transition [:refused, :booked, :accepted, :closed] => :pending
    # end
  # end

  def restricted?
    proposals.restricted.present? ? true : false
  end

  def restricted
    proposals.try(:restricted).try(:first)
  end

  def create_documents
    documents.create([{name: 'irs_id'},{name: 'contract'}])
  end

end