class MailerMethod::PriceList < MailerMethod::Base

  def name
    :price_list
  end

  def object
    @object ||= Build.first
  end

  def signed_in?
    false
  end

  def subject
    I18n.t(:subject, scope:'helpers.mailer.price_list', build: @object.name)
  end

  def url
    public_dashboards_path
  end

  def store
    @object.store
  end

  def attributes
    {method_name: name, subject: subject, body: render, url: url, send_at: Date.today, store: store}
  end

  def deliver_mail
    self.mailer.senders.each do  |sender|
      ApplicationMailer.dispach(mailer.header.merge(to: sender.to)).deliver
      sender.update_attribute(:updated_at, DateTime.now)
    end
    # return true
    # else
    # return mailer.errors
    # end    
  end

end