class ApplicationMailer < ActionMailer::Base
  default from: 'bperucchi@gmail.com'
  
  def dispach(options={})
    from = options[:from] || 'bperucchi@gmail.com'
    to = options[:to]
    subject = options[:subject]
    body = options[:body]
    mail(from: from, to: to, subject: subject) do |format|
      format.html {render :text => body}
    end
  end
end