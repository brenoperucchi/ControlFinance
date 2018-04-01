class MailerMethod::Base
  include Rails.application.routes.url_helpers

  HOST = ActionMailer::Base.default_url_options[:host]
  PORT = ActionMailer::Base.default_url_options[:port]

  def initialize(obj = nil)
    @object = obj || object
  end

  def render
    options = Rails.application.routes.default_url_options
    view = ApplicationController.renderer.new(http_host: options[:host])
    view.extend ApplicationHelper
    # view = ActionView::Base.new(Rails.configuration.paths['app/views'], {})
    # view = ActionView::Base.new(ActionController::Base.view_paths, {})  
    # view.request = self.request
    # view.config = Rails.application.config
    # view.controller = ActionController::Base.new
    # view.controller.request =  ActionDispatch::Request.new(request)
    # view.controller.response = ActionController::Response.new
    # view.controller.headers = Rack::Utils::HeaderHash.new
    view.class_eval do       
      include Rails.application.routes.url_helpers
      include ApplicationHelper

      def default_url_options
        Rails.application.routes.default_url_options
      end

      def protect_against_forgery?
        false
      end
    end
    view.render partial: "mailers/#{name.to_s}", locals: { object: @object, token:token, host: HOST, port: PORT }, layout:false
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
      return false
    end
    
  end

  private
    def generate_token
      @token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless Mailer.exists?(token: random_token)
      end
    end

end