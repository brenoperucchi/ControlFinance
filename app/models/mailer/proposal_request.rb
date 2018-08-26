class Mailer::ProposalRequest < Mailer

  serialize :mailer_method, MailerMethod::ProposalRequest
  
  has_many :senders, class_name: "MailerSender", dependent: :destroy, as: :mailerable

  attr_accessor :brokers, :delivery_emails

  validates_presence_of :to, allow_blank: false

  def name
    :proposal_request
  end

  def prepare
    provider_class = "MailerMethod::#{name.to_s.classify}".constantize
    self.mailer_method = provider_class.new(object: mailable, to: to, subject: subject, body: body, token: token)
    self.token = mailer_method.token
    self.subject = mailer_method.subject
    self.body = mailer_method.body || mailer_method.render
    senders.new(mailer_method.attributes)
  end

  def create_broker
    if ActiveRecord::Type::Boolean.new.cast(self.register_broker)
      to.split(",").each do |email|
        broker = store.brokers.new(name: email, department:'user', person_type:'person', active:1, option1: '1', option2: '1', option3: '1', option4: '1', option5: '1', option6: '1', address: 'Address', phone: 'Phone' , company_irs_id: 'company_irs_id', irs_id: "IRS ID #{store.brokers.last.id + 1}", user_attributes:{email: email, password: '123123', store: store})
        return false
      end
    end
  end


end