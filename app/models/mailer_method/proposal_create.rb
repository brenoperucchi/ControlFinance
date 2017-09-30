class MailerMethod::ProposalCreate < MailerMethod::Base

  def name
    :proposal_create
  end

  def object
    @object ||= ::Proposal.first
  end

  def signed_in?
    true
  end

  def subject
    I18n.t(:subject, scope:'helpers.mailer.create', unit: @object.unit.name, build: @object.builder.name)
  end

  def url
    edit_public_proposal_path(@object)
  end

  def attributes
    {method_name: name, to: @object.broker.user.email, subject: subject, body: render, token: token, url: url, send_at: Date.today, userable:@object.broker}
  end

end