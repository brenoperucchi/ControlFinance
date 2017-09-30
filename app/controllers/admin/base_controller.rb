class Admin::BaseController < ApplicationController

  layout 'elite'
  
  protect_from_forgery

  before_action :authenticate_admin!
  
  def authenticate_admin!
    if not(user_signed_in?)
      redirect_to(admin_new_session_path)
    elsif not current_user.userable.admin?
      sign_out current_user
      redirect_to admin_new_session_path, notice: "User not Admin"
    end
  end

end