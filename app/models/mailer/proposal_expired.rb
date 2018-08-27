class Mailer::ProposalExpired < Mailer

  serialize :mailer_method, MailerMethod::ProposalExpired

  def name
    :proposal_expired
  end

  def prepare
    provider_class = "MailerMethod::#{name.to_s.classify}".constantize
    mailer_method = provider_class.new(object: mailable)
    self.senders.new(mailer_method.attributes)
  end

  def delivery
    mailable.pending # proposal pending
    super
  end

end