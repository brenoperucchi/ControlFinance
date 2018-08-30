class Mailer::NoteCreated < Mailer
  
  serialize :mailer_method, MailerMethod::NoteCreated

  def name
    :note_created
  end

  def prepare
    provider_class = "MailerMethod::#{name.to_s.classify}".constantize
    mailer_method = provider_class.new(object: mailable)
    self.token = mailer_method.token
    self.subject = mailer_method.subject
    self.body = mailer_method.body
    self.senders.new(mailer_method.attributes)
  end

  def object_method
    self.type.classify
  end

end