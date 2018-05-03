class Mailer < ApplicationRecord

  store :parameters, accessors:[:from, :to, :subject, :body, :mailers]

  belongs_to :mailable, polymorphic: true
  belongs_to :userable, polymorphic: true, optional:true
  belongs_to :store

  validates_presence_of :to, :subject

  validates_uniqueness_of :token, :on => :create, :message => "Reload Page"

  def header
    {to: self.to, subject: self.subject, body: self.body, from: (self.from || store.email)}
  end

end