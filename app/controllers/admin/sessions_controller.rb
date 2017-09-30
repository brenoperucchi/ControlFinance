class Admin::SessionsController < Devise::SessionsController

  layout 'empty'

  def after_sign_in_path_for(resource)
    current_user.userable.admin? ? admin_builds_path : public_builds_path
  end

  def after_sign_out_path_for(resource)
    admin_builds_path 
  end
end