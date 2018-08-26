class Mailer::ProposalExpired < Mailer

  serialize :mailer_method, MailerMethod::ProposalExpired
  
  has_many :senders, class_name: "MailerSender", dependent: :destroy, as: :mailerable

  def name
    :proposal_expired
  end

  def prepare
    provider_class = "MailerMethod::#{name.to_s.classify}".constantize
    self.mailer_method = provider_class.new(object: mailable)
    self.senders.new(mailer_method.attributes)
  end

  def delivery
    mailable.pending
    super
  end

end