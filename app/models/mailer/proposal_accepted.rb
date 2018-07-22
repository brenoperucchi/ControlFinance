class Mailer::ProposalAccepted < Mailer

  serialize :mailer_method, MailerMethod::ProposalAccepted

  def name
    :proposal_accepted
  end

  def prepare
    provider_class = "MailerMethod::#{name.to_s.classify}".constantize
    self.mailer_method = provider_class.new(object: mailable)
    self.senders.new(mailer_method.attributes)
  end

end