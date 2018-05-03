class ApplicationMailer < ActionMailer::Base
  # default from: current_store.email
  
  def dispach(options={})
    from = options[:from] 
    to = options[:to]
    subject = options[:subject]
    body = options[:body]
    mail(from: from, to: to, subject: subject, content_type: "text/html") do |format|
      format.html {render inline: body}
    end
  end
end