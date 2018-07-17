class Mailer::ProposalCreate < Mailer
  store :parameters, accessors:[:to, :from, :subject, :body, :register_broker, :url, :signed_in?, :token]

  attr_accessor :brokers, :delivery_emails

  validates_presence_of :to, allow_blank: false

  def name
    :proposal_create
  end

  def prepare
    provider_class = "MailerMethod::#{name.to_s.classify}".constantize
    self.mailer_method = provider_class.new(object: mailable)
    self.token = self.mailer_method.token
    self.subject = self.mailer_method.subject
    self.body = self.mailer_method.body
    senders.new(self.mailer_method.attributes)
  end

end