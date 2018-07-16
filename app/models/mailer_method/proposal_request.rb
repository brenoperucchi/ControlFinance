  class MailerMethod::ProposalRequest < MailerMethod::Base

  def name
    :proposal_request
  end

  def object
    @object
  end


  def signed_in?
    false
  end

  def subject
    I18n.t(:subject, scope:'helpers.mailer.request', unit: @object.name)
  end

  def url
    public_build_units_path(@object)
  end

  def store
    @object.builder.store
  end

  def attributes
    {subject: subject, body: render, token: token, url: url, signed_in?: signed_in?}
  end

end