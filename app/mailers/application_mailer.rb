class ApplicationMailer < ActionMailer::Base
  default from: 'bperucchi@gmail.com'
  
  def dispach(options={})
    from = options[:from] || 'bperucchi@gmail.com'
    to = options[:to]
    subject = options[:subject]
    body = options[:body]
    mail(from: from, to: to, subject: subject, content_type: "text/html") do |format|
      format.html {render inline: body}
    end
  end
end