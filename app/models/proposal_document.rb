class ProposalDocument < ApplicationRecord

  belongs_to :proposal

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