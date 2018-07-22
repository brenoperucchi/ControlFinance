class Mailer::ProposalCreate < Mailer

  serialize :mailer_method, MailerMethod::ProposalCreate

  def name
    :proposal_create
  end

  def prepare
    provider_class = "MailerMethod::#{name.to_s.classify}".constantize
    self.mailer_method = provider_class.new(object: mailable)
    self.token = mailer_method.token
    self.subject = mailer_method.subject
    self.body = mailer_method.body
    self.senders.new(mailer_method.attributes)
  end

end