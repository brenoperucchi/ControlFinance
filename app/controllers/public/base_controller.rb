class Public::BaseController < ApplicationController
  include PublicActivity::StoreController

  layout 'public'
  
  protect_from_forgery with: :null_session

  before_action :authenticate_user!
  
  def authenticate_user!
    if not(user_signed_in?)
      redirect_to(public_builds_path, alert: I18n.t(:unauthenticated, scope: 'devise.failure'))
    end
  end

end