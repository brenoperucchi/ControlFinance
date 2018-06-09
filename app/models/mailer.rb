class Mailer < ApplicationRecord
  attr_accessor :register_user, :method, :brokers, :mailer_method, :to
  store :parameters, accessors:[:from, :subject, :body, :mailers]

  has_many :senders, class_name: "MailerSender", dependent: :destroy
  belongs_to :mailable, polymorphic: true
  belongs_to :userable, polymorphic: true, optional: true
  belongs_to :store, optional: true

  validates_presence_of :to, :subject

  before_validation :method_prepare

  def create_mailers
    to.first.split(",").each do |email|
      if ActiveRecord::Type::Boolean.new.cast(self.register_user)
        broker = store.brokers.new(name: email, department:'user', person_type:'person', active:1, option1: '1', option2: '1', option3: '1', option4: '1', option5: '1', option6: '1', address: 'Address', phone: 'Phone' , company_irs_id: 'company_irs_id', irs_id: "IRS ID #{store.brokers.last.id + 1}", user_attributes:{email: email, password: '123123', store: store})
        self.errors.add(:to, broker.errors.full_messages.first) if not broker.save
      end
    end
    mailers_to_send.each do |to_send|
      unless senders.where(to: to_send).take
        senders.create(to: to_send, token: mailer_method.token)
      end
    end
  end

  def header
    {to: self.to, subject: self.subject, body: self.body, from: (self.from || store.email)}
  end

  def method_prepare
    self.mailer_method = ("MailerMethod::#{self.method.classify}".constantize.new(self.mailable))
    self.attributes = mailer_method.attributes
    self.errors.add(:to, "need be presence") if mailers_to_send.blank?
    self.errors.add(:brokers, "need be presence") if mailers_to_send.blank?
  end

  def delivery
    self.create_mailers
    mailer_method.mailer = self
    mailer_method.custom_procedures if self.mailer_method.respond_to?(:custom_procedures)
    mailer_method.deliver_mail
  end

  private

  def mailers_to_send
    to_send = (store.brokers.where(id:self.brokers).map{|b| b.user.email}) 
    to_send << self.to.first.split(",")
    to_send.flatten.delete_if(&:blank?)
  end
end