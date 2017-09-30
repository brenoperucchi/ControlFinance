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
    public_builds_path
  end

  def attributes
    {method_name: name, subject: subject, body: render, token: token, url: url, send_at: Date.today}
  end

end