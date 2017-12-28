class Public::BaseController < ApplicationController
  include PublicActivity::StoreController

  layout 'elite'
  
  protect_from_forgery with: :null_session

  before_action :authenticate_user!
  
  def authenticate_user!
    if not(user_signed_in?)
      redirect_to(new_user_session_path, alert: I18n.t(:unauthenticated, scope: 'devise.failure'))
    end
  end

  def current_store
    ## TODO MODIFY AFTER BETA IN SALES PRODUCTION 
    param = params[:store_id]|| 1
    Store.current = Store.find_by_id(param)
  end

end