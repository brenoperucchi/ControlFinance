class Admin::BaseController < ApplicationController
  layout 'pages'

  protect_from_forgery
  before_action :authenticate_admin!
  helper_method :current_store
  
  def authenticate_admin!
    if not(user_signed_in?)
      redirect_to(admin_new_session_path)
    elsif not current_user.userable.admin?
      sign_out current_user
      redirect_to admin_new_session_path, notice: "Need to be Admin"
    end
  end

  def current_store
    user_id = current_user.try(:userable).try(:id)
    session[:store_id] = user_id || nil if session[:store_id] != user_id 
    session[:store_id] ||= Store.where(url: request.subdomain.split('.').first).take
    Store.current = Store.find_by_id(session[:store_id])
  end

end