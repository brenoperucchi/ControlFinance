class Document < ApplicationRecord
  attr_accessor :validated, :status

  STATUS = {pending: 'cancel', approved:'approve'}

  belongs_to :documentable, polymorphic: true
  has_many :assets, class_name: "Asset",    as: :assetable, dependent: :destroy

  validate :validate_state, if: Proc.new {|obj| obj.validated.nil? and not obj.status.nil?}

  def validate_state
    return true if STATUS[self.state.to_sym] == STATUS[self.status.to_sym]
    self.validated = false
    # self.class.public_activity_off
    if send(STATUS[status.to_sym])
      true
    else
      errors.add(:status, :invalid)
    end
    # self.class.public_activity_on
  end

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
end