class Public::SessionsController < Devise::SessionsController

  layout 'empty'

  def after_sign_in_path_for(resource)
    !current_user.userable.admin? ? public_builds_path : admin_builds_path
  end

  def after_sign_out_path_for(resource)
    public_builds_path
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

end