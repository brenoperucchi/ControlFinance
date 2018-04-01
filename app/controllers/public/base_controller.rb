class Public::BaseController < ApplicationController
  include PublicActivity::StoreController

  layout 'elite'
  
  protect_from_forgery with: :null_session

  before_action :authenticate_user!
  
  def authenticate_user!
    if not(user_signed_in?)
      respond_to do |format|
        format.html { redirect_to(new_user_session_path, alert: I18n.t(:unauthenticated, scope: 'devise.failure')) }
        format.js do 
          flash[:alert] = I18n.t(:unauthenticated, scope: 'devise.failure')
          render :js => "window.location.href='"+new_user_session_path+"'" 
        end
      end
      
    end
  end

  def current_store
    ## TODO MODIFY AFTER BETA TEST
    ## this should have baseline with subdomain in http
    param = params[:store_id] || 1
    param = current_user.userable.store.id if user_signed_in?
    Store.current = Store.find_by_id(param)
  end

end