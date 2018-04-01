class Broker < ApplicationRecord
  STATES = {pending: 'cancel', approved:'approve'}

  include Lib::Personhood
  include PublicActivity::Model
  attr_accessor :comment

  store :serializes, accessors:[:option1, :option2, :option3, :option4, :option5, :option6, :address, :phone, :company_irs_id]
  
  tracked :only =>[:update], 
          :owner      =>  proc {|controller, model| User.current.userable},
          :recipient  =>  proc {|controller, model| model.store},
          :params => {
                      :comment => proc {|contronller, model| model.comment},
                     },
          :on => {
                   :update => proc {|model, controller| !model.comment.blank? }
                 }  
  after_create :create_documents

  belongs_to :store, optional: true
  has_one :user, as: :userable, dependent: :destroy
  has_many :proposals, class_name: 'Proposal', foreign_key: "broker_id", dependent: :destroy
  has_many :assets,    class_name: "Asset",    as: :assetable, dependent: :destroy
  has_many :documents, class_name: "Document", as: :documentable, dependent: :destroy

  scope :users, ->{ joins(:user).where(users:{userable_type: 'Broker'}) }

  accepts_nested_attributes_for :user, allow_destroy: true  

  validates :option1, :option2, :option3, :option4, :option5, :option6, acceptance: { accept: true }, on: :create
  validates_presence_of :name, :option1, :option2, :option3, :option4, :option5, :option6, on: :create
  validates_uniqueness_of :irs_id, scope:[:store_id]

  accepts_nested_attributes_for :user

  state_machine initial: :pending do    
    after_transition :pending => :approved, :do => :update_state
    after_transition :approved => :pending, :do => :update_state

    event :approve do 
      transition [:pending] => :approved
    end
    event :cancel do
      transition [:approved] => :pending
    end

    state :approved do
      def update_state(state)
        self.update_column(:approved_at, DateTime.now)
      end
    end
    state :pending do
      def update_state(state)
        self.update_column(:approved_at, nil)
      end
    end
  end
  
  def proposal_accepted?
    proposals.accepted.present? ? true : false
  end

  def proposal_accepted
    proposals.try(:accepted).try(:first)
  end

  def create_documents
    documents.create([
      {name: 'irs_id', kind:'irs_id'},
      {name: 'contract', kind:'contract'}
    ])
  end

end