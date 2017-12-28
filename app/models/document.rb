class Document < ApplicationRecord

  belongs_to :documentable, polymorphic: true
  has_many :assets, class_name: "Asset",    as: :assetable, dependent: :destroy

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