class Mailer < ApplicationRecord

  store :parameters, accessors:[:from, :to, :subject, :body, :mailers]

  attr_accessor :register_user

  belongs_to :mailable, polymorphic: true
  belongs_to :userable, polymorphic: true, optional: true
  belongs_to :store, optional: true

  validates_presence_of :to, :subject

  validates_uniqueness_of :token, :on => :create, :message => "Reload Page"

  def header
    {to: self.to, subject: self.subject, body: self.body, from: (self.from || store.email)}
  end

  def create_broker
    self.to.each do |email|
      conditional = ActiveRecord::Type::Boolean.new.cast(self.register_user)
      conditional2 = store.users.where(email: email).take
      if conditional and not email.empty? and not conditional2
        broker = store.brokers.create(name: email, department:'user', person_type:'person', active:1, option1: '1', option2: '1', option3: '1', option4: '1', option5: '1', option6: '1', address: 'Address', phone: 'Phone' , company_irs_id: 'company_irs_id', irs_id: "IRS ID #{store.brokers.last.id + 1}", user_attributes:{email: email, password: '123123', store: store})
      end
    end
  end

end