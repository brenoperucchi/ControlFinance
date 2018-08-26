class MailerMethod::ProposalAccepted < MailerMethod::Base

  def name
    :proposal_accepted
  end

  def object
    @object
  end

  def sign_in?
    true
  end

  def subject
    I18n.t(:subject, scope:'helpers.mailer.accepted', unit: @object.unit.name, build: @object.builder.name)
  end

  def url
    public_purchase_steps_path(@object) 
  end

  def store
    @object.builder.store
  end

  def attributes
    {to: @object.broker.user.email, subject: subject, body: body, url: url, send_at: Date.today, token: token, sign_in?: sign_in?}
  end

end