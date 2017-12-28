class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  include SentientController

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_admin?, :current_store
  before_action :flash_clean
  before_action :set_locale
   
  def set_locale
    I18n.locale = 'pt-BR'
  end

  def flash_clean
    flash.discard
  end

  def current_admin?
    current_user.try(:userable).try(:admin?)
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
  end

end