class MailerMethod::ProposalExpireToday < MailerMethod::Base

  def name
    :proposal_expire_today
  end

  def object
    @object
  end

  def sign_in?
    false
  end

  def subject
    @subject.blank? ? I18n.t(:subject, scope:'helpers.mailer.request', unit: @object.name) : @subject
  end

  def url
    public_build_units_path(@object.builder)
  end

  def store
    @object.builder.store
  end

  def attributes
    {to: object.broker.user.email, subject: subject, body: body, token: token, url: url, sign_in?: sign_in?}
  end

end