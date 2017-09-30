class MailerMethod::ProposalAccepted < MailerMethod::Base

  def name
    :proposal_accepted
  end

  def object
    @object ||= ::Proposal.first
  end

  def signed_in?
    true
  end

  def subject
    I18n.t(:subject, scope:'helpers.mailer.accepted', unit: @object.unit.name, build: @object.builder.name)
  end

  def url
    public_purchase_steps_path(@object, :proposal) 
  end

  def attributes
    {method_name: name, to: @object.broker.user.email, subject: subject, body: render, token: token, url: url, send_at: Date.today, userable:@object.broker}
  end

end