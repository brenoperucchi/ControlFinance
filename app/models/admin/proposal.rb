class Admin::Proposal < Proposal
  include PublicActivity::Common
  attr_accessor :validated, :states

  validate :validate_state, if: Proc.new {|obj| obj.validated.nil? and not obj.states.nil?}
  # before_save :state_update
  after_create   :create_notes

  ## MENTORIA
  ## notes.create 
  def create_notes
    notes.create(unit: unit, broker: broker, action: state, admin_id: admin_id, comment: comment)
  end

  private
  
  def state_update
    if self.state_changed?
      self.create_activity :create, owner: proc {|controller, model| User.current.userable},
      :recipient  =>  proc {|controller, model| model.unit},
      :params     => { :comment => proc {|contronller, model| I18n.t :state_change, scope:'helpers.proposal', from: self.state_change[0], to: self.state_change[1]} }
    end
  end

  def validate_state
    return true if self.state.to_sym == self.states.to_sym
    self.validated = false
    # self.class.public_activity_off
    if send(STATUS[states.to_sym])
      true
    else
      return false
    end
    # self.class.public_activity_on
  end
end