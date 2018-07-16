class Mailer < ApplicationRecord

  store :parameters, accessors:[:to, :from, :subject, :body, :mailer_method]

  has_many :senders, class_name: "MailerSender", dependent: :destroy
  belongs_to :mailable, polymorphic: true
  belongs_to :userable, polymorphic: true, optional: true
  belongs_to :store, optional: true


  def delivery
    unless self.deliver_mail()
      self.errors.add(:to, broker.errors.full_messages.first) if not broker.save
    end
  end

end