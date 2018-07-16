class MailerMethod::Base
  include Rails.application.routes.url_helpers

  def initialize(obj = nil)
    @object = obj# || objec
  end

  def body
    @body ||= render
  end

  def token
    @token ||= generate_token
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
    view.render partial: "mailers/#{name.to_s}", locals: {object: @object, token: token, host: self.host}, layout:false
  end

  def host
    options = Rails.configuration.action_mailer.default_url_options
    "#{store.url}.#{options[:host]}:#{options[:port]}"
  end

  private
    def generate_token
      @token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless MailerSender.exists?(token: random_token)
      end
    end

end