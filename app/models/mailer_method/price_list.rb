class MailerMethod::PriceList
  include ActiveModel::Model

  attr_accessor :to, :brokers, :register_user, :subject

  validates_presence_of :to, allow_blank: false, exclusion:{in:[""]}

  def initialize(args = {})
    self.to = args[:to]
    self.subject = args[:subject]
    self.brokers = args[:brokers]
    self.register_user = args[:register_user]
  end

  # def name
  #   :price_list
  # end

  # def object
  #   @object ||= Build.first
  # end

  # def signed_in?
  #   false
  # end

  # def subject
  #   I18n.t(:subject, scope:'helpers.mailer.price_list', build: @object.name)
  # end

  # def url
  #   public_dashboards_path
  # end

  # def store
  #   @object.store
  # end

  # def attributes
  #   {method_name: name, subject: subject, body: render, url: url, send_at: Date.today, store: store}
  # end

  # def deliver_mail
  #   self.mailer.senders.each do  |sender|
  #     ApplicationMailer.dispach(mailer.header.merge(to: sender.to)).deliver
  #     sender.update_attribute(:updated_at, DateTime.now)
  #   end
  #   # return true
  #   # else
  #   # return mailer.errors
  #   # end    
  # end

end