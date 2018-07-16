class Mailer::PriceList < Mailer
  store :parameters, accessors:[:to, :from, :subject, :body, :register_broker, :url, :signed_in?, :token]

  attr_accessor :brokers, :delivery_emails

  validates_presence_of :to, allow_blank: false

  def name
    :price_list
  end

  def prepare
    provider_class = "MailerMethod::#{name.to_s.classify}".constantize
    self.create_broker
    email_list.flatten.each do |email|
      self.mailer_method = provider_class.new(mailable)
      senders.new(self.mailer_method.attributes.merge(to: email))
    end
  end

  def deliver_mail
    senders.each do  |sender|
      ApplicationMailer.dispach(sender.header.merge(from: (self.from || store.email))).deliver
      sender.update_attribute(:send_at, DateTime.now)
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