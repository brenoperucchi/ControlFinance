class MailerSender < ApplicationRecord
  store :information, accessors:[:from, :subject, :body, :url, :mailers, :register_user, :signed_in?]

  # belongs_to :mailer, optional: true
  belongs_to :mailerable, polymorphic: true, optional: true
  validates_uniqueness_of :token, :on => :create, :message => "Reload Page"

  def mailerable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end


  def header
    {to: to, subject: subject, body: body, from: from }
  end

end