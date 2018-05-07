class Admin::SessionsController < Devise::SessionsController

  layout 'pages/empty'

  def after_sign_in_path_for(resource)
    current_user.userable.admin? ? admin_dashboards_path : public_dashboards_path
  end

  def after_sign_out_path_for(resource)
    admin_new_session_path 
  end
end