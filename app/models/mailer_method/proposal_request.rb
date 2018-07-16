class MailerMethod::ProposalRequest < MailerMethod::Base

  attr_writer :subject
  attr_accessor :to, :body

  def name
    :proposal_request
  end

  def object
    @object
  end

  def token
    @token = @token.blank? ? generate_token : @token
  end

  def signed_in?
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
    {to: to, subject: subject, body: body, token: token, url: url, signed_in?: signed_in?}
  end

end