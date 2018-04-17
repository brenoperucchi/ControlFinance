require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  include PublicActivity::StoreController
  include SentientController

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_admin?, :current_store
  # after_action :flash_clean
  before_action :set_locale
   
  def set_locale
    I18n.locale = self.try(:current_store).try(:language) || 'pt-BR'
  end

  # def flash_clean
  #   flash.discard
  # end

  def current_admin?
    current_user.try(:userable).try(:admin?)
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
  end

end