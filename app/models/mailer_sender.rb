class MailerSender < ApplicationRecord
  store :information, accessors:[:from, :subject, :body, :mailers]
  belongs_to :mailer, optional: true
  validates_uniqueness_of :token, :on => :create, :message => "Reload Page"

end