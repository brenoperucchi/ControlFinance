class Mailer::PriceList < Mailer

  serialize :mailer_method, MailerMethod::PriceList

  attr_accessor :brokers, :delivery_emails

  validates_presence_of :subject#, allow_blank: false
  validate :validate_to

  def validate_to
    errors.add(:to, I18n.t(:blank, scope:'errors.messages', attribute: :to)) if to.detect{|x| x.empty?}
  end

  def name
    :price_list
  end

  def prepare
    provider_class = "MailerMethod::#{name.to_s.classify}".constantize
    mailer_method = provider_class.new(object: mailable, subject: subject)
    self.subject = mailer_method.subject
    self.create_broker
    email_list.flatten.each do |email|
      mailer_method.to = email
      mailer_method.token = mailer_method.generate_token
      mailer_method.body = mailer_method.render
      senders.new(mailer_method.attributes)
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