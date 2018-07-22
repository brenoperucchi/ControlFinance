class MailerMethod::PriceList <  MailerMethod::Base

  def name
    :price_list
  end

  def object
    @object 
  end

  def signed_in?
    false
  end

  def subject
    @subject.blank? ? I18n.t(:subject, scope:'helpers.mailer.price_list', build: @object.name) : @subject
  end

  def url
    public_dashboards_path
  end

  def store
    @object.store
  end

  def attributes
    {to: to, subject: subject, body: body, url: url, token: token, url: url, signed_in?: signed_in?}
  end

end