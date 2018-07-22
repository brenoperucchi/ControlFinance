class MailerMethod::ProposalCreate < MailerMethod::Base

  def name
    :proposal_create
  end

  def object
    @object
  end

  def signed_in?
    true
  end

  def subject
    I18n.t(:subject, scope:'helpers.mailer.create', unit: @object.unit.name, build: @object.unit.builder.name)
  end

  def url
    invoice_public_proposal_path(@object)
  end

  def store
    @object.builder.store
  end

  def attributes
    {to: @object.broker.user.email, subject: subject, body: body, url: url, send_at: Date.today, token: token}
  end

end