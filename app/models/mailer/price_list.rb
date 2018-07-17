class Mailer::PriceList < Mailer
  store :parameters, accessors:[:to, :from, :subject, :body, :register_broker, :url, :signed_in?, :token]

  attr_accessor :brokers, :delivery_emails

  validates_presence_of :to, allow_blank: false

  def name
    :price_list
  end

  def prepare
    provider_class = "MailerMethod::#{name.to_s.classify}".constantize
    self.mailer_method = provider_class.new(object: mailable, subject: subject)
    self.subject = self.mailer_method.subject
    self.create_broker
    email_list.flatten.each do |email|
      self.mailer_method.to = email
      self.mailer_method.token = self.mailer_method.generate_token
      self.mailer_method.body = self.mailer_method.render
      senders.new(self.mailer_method.attributes)
    end

  end

  def create_broker
    if ActiveRecord::Type::Boolean.new.cast(self.register_broker)
      to.first.split(",").each do |email|
        broker = store.brokers.new(name: email, department:'user', person_type:'person', active:1, option1: '1', option2: '1', option3: '1', option4: '1', option5: '1', option6: '1', address: 'Address', phone: 'Phone' , company_irs_id: 'company_irs_id', irs_id: "IRS ID #{store.brokers.last.id + 1}", user_attributes:{email: email, password: '123123', store: store})
        broker.save
      end
    end
  end

  private

  def email_list
    emails = (store.brokers.where(id:self.brokers).map{|b| b.user.email}) 
    emails << self.to.first.split(",") unless self.to.nil?
    emails.uniq.delete_if(&:blank?).flatten
  end

end