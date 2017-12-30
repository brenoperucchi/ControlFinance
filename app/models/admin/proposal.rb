class Admin::Proposal < Proposal

  attr_accessor :validated, :status

  validate :validate_state, if: Proc.new {|obj| obj.validated.nil? and not obj.status.nil?}

  def validate_state
    return true if STATUS[self.state.to_sym] == STATUS[self.status.to_sym]
    self.validated = false
    self.class.public_activity_off
    if send(STATUS[status.to_sym])
      true
    else
      errors.add(:status, :invalid)
    end
    self.class.public_activity_on
  end

end