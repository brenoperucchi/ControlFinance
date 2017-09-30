class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  include SentientController

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_admin?, :current_store

  def current_admin?
    current_user.try(:userable).try(:admin?)
  end

  def current_store
    user_id = current_user.try(:userable).try(:id)
    session[:store_id] = user_id || nil if session[:store_id] != user_id 
    # session[:store_id] ||= user_id || nil
    Store.current = Store.find_by_id(session[:store_id])
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
    end

end