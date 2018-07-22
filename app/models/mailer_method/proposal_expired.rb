class MailerMethod::ProposalExpired < MailerMethod::Base

  def name
    :proposal_expired
  end

  def object
    @object
  end

  def signed_in?
    true
  end

  def subject
    I18n.t(:subject, scope:'helpers.mailer.expired', unit: @object.unit.name)
  end

  def store
    @object.builder.store
  end

  def url
    edit_public_proposal_path(@object)
  end

  def attributes
    {to: @object.broker.user.email, subject: subject, body: body, token: token, url: url, signed_in?: signed_in?}
  end

  # def custom_procedures
  #   @object.pending
  # end

end