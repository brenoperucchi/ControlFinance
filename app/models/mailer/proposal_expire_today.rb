class Mailer::ProposalExpireToday < Mailer

  serialize :mailer_method, MailerMethod::ProposalExpireToday

  def name
    :proposal_expire_today
  end

  def prepare
    mailer_klass = "MailerMethod::#{name.to_s.classify}".constantize
    mailer_method = mailer_klass.new(object: mailable)
    self.senders.new(mailer_method.attributes)
  end

  # def delivery
  #   # mailable.pending # proposal pending
  #   super
  # end

end