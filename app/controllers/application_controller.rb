require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  include PublicActivity::StoreController
  include SentientController

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_admin?, :current_store, :back_url
  before_action :set_locale

  def back_url
   if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
     URI(request.referer).path
   else
     root_url
   end
  end
   
  def set_locale
    I18n.locale = self.try(:current_store).try(:language) || 'pt-BR'
  end

  def current_admin?
    current_user.try(:userable).try(:admin?)
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
  end

end