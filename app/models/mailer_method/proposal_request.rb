  class MailerMethod::ProposalRequest < MailerMethod::Base

  def name
    :proposal_request
  end

  def object
    @object ||= Unit.first
  end


  def signed_in?
    false
  end

  def subject
    I18n.t(:subject, scope:'helpers.mailer.request', unit: @object.name)
  end

  def url
    new_public_unit_proposal_path(@object)
  end

  def store
    @object.builder.store
  end

  def attributes
    {method_name: name, subject: subject, body: render, token: token, url: url, send_at: Date.today, store: store}
  end

end