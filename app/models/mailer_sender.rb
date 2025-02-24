class MailerSender < ApplicationRecord
  store :information, accessors:[:from, :subject, :body, :url, :mailers, :register_user, :sign_in?]

  belongs_to :mailer, optional: true
  validates_uniqueness_of :token, :on => :create, :message => "Reload Page"

  def header
    {to: to, subject: subject, body: body, from: from }
  end

end