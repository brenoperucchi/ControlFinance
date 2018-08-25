class Mailer < ApplicationRecord
  
  store :parameters, accessors:[:to, :from, :subject, :body, :register_broker, :url, :signed_in?, :token]

  has_many :senders, class_name: "MailerSender", dependent: :destroy
  belongs_to :mailable, polymorphic: true
  belongs_to :userable, polymorphic: true, optional: true
  belongs_to :store, optional: true
  belongs_to :owner, optional: true, class_name: 'User'


  def delivery
    unless self.deliver_mail
      self.errors.add(:to, broker.errors.full_messages.first) if not broker.save
    end
  end

  def deliver_mail
    senders.each do  |sender|
      MailerWorker.perform_async(sender.header.merge(from: (self.from || store.email)))
      sender.update_attribute(:send_at, DateTime.now)
    end
  end

end