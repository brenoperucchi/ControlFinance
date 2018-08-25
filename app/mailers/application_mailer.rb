class ApplicationMailer < ActionMailer::Base
  
  def dispach(options={})
    from = options['from'] 
    to = options['to']
    subject = options['subject']
    body = options['body']
    mail(from: from, to: to, subject: subject, content_type: "text/html") do |format|
      format.html { render inline: body.to_s.html_safe }
    end
  end
end