class Public::BaseController < ApplicationController
  include PublicActivity::StoreController

  layout 'pages'
  protect_from_forgery with: :null_session
  before_action :authenticate_user!
  helper_method :current_store

  def current_store
    Store.all.each do |store|
      store.url.split(';').each do |url|
        @current_store = store if request.subdomain.split('.').first.downcase == url.downcase.strip
      end
    end
    @current_store
  end

  
  def authenticate_user!
    if not(user_signed_in?)
      respond_to do |format|
        format.html { redirect_to(new_user_session_path )}#, alert: I18n.t(:unauthenticated, scope: 'devise.failure')) }
        format.js do 
          flash[:alert] = I18n.t(:unauthenticated, scope: 'devise.failure')
          render :js => "window.location.href='"+new_user_session_path+"'" 
        end
      end
    else
      if current_user.userable.admin?
        sign_out current_user
        respond_to do |format|
          format.html { redirect_to(new_user_session_path )}#, alert: I18n.t(:unauthenticated, scope: 'devise.failure')) }
          format.js do 
            flash[:alert] = I18n.t(:unauthenticated, scope: 'devise.failure')
            render :js => "window.location.href='"+new_user_session_path+"'" 
          end
        end

      end  
    end
  end

end