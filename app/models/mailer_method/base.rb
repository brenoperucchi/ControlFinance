class MailerMethod::Base
  include Rails.application.routes.url_helpers

  HOST = ActionMailer::Base.default_url_options[:host]
  PORT = ActionMailer::Base.default_url_options[:port]

  def initialize(obj = nil)
    @object = obj || object
  end

  def render
    view = ApplicationController.renderer.new(http_host: self.host)
    view.extend ApplicationHelper
    view.class_eval do       
      include Rails.application.routes.url_helpers
      include ApplicationHelper

      def default_url_options
        # Rails.configuration.action_mailer.default_url_options[:host]
      end
      def protect_against_forgery?
        false
      end
    end
    view.render partial: "mailers/#{name.to_s}", locals: { object: @object, token:token, host: self.host }, layout:false
  end

  def token
    @token ||= generate_token
  end

  def deliver_mail
    mailer = @object.mailers.new(self.attributes)
    if mailer.save
      ApplicationMailer.dispach(mailer.header).deliver
      self.custom_procedures if self.respond_to?(:custom_procedures)
      return true
    else
      return mailer.errors
    end    
  end

  def host
    options = Rails.configuration.action_mailer.default_url_options
    "#{store.url}.#{options[:host]}:#{options[:port]}"
  end

  private
    def generate_token
      @token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless Mailer.exists?(token: random_token)
      end
    end

end