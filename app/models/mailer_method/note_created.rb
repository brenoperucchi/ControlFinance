class MailerMethod::NoteCreated < MailerMethod::Base

  def name
    :note_created
  end

  def object
    @object
  end

  def sign_in?
    true
  end

  def subject
    I18n.t(:subject, scope:'helpers.mailer.note_created', unit: @object.unit.name, build: @object.unit.builder.name)
  end

  def url
    invoice_public_proposal_path(@object)
  end

  def store
    @object.unit.builder.store
  end

  def attributes
    {to: @object.broker.user.email, subject: subject, body: body, url: url, send_at: Date.today, token: token, sign_in?: sign_in?}
  end

end