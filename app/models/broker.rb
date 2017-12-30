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

  store :serializes, accessors:[:option1, :option2, :option3, :option4, :option5, :option6, :address, :phone, :company_irs_id]
  
  belongs_to :store, optional: true
  has_one :user, as: :userable, dependent: :destroy
  has_many :proposals, class_name: 'Proposal', foreign_key: "broker_id", dependent: :destroy
  has_many :assets,    class_name: "Asset",    as: :assetable, dependent: :destroy
  has_many :documents, class_name: "Document", as: :documentable, dependent: :destroy

  scope :users, ->{ joins(:user).where(users:{userable_type: 'Broker'}) }

  accepts_nested_attributes_for :user, allow_destroy: true  

  validates :option1, :option2, :option3, :option4, :option5, :option6, acceptance: { accept: '1' }, on: :create
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