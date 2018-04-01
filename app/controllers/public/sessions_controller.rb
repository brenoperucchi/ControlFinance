class Public::SessionsController < Devise::SessionsController

  layout 'pages/empty'

  def after_sign_in_path_for(resource)
    !current_user.userable.admin? ? public_dashboards_path : admin_builds_path
  end

  def after_sign_out_path_for(resource)
    public_dashboards_path
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = resource_class.new(sign_in_params)
    referer = stored_location_for(resource) || request.referer || root_path
    @user = User.find_by_email(params[:user][:email])
    if @user.nil?
      redirect_to(new_public_broker_path, alert: I18n.t(:unauthenticated_email, scope: 'devise.failure')) 
    elsif @user.userable.admin?
      redirect_to admin_new_session_path, alert: I18n.t(:unauthenticated, scope: 'devise.failure')
    else
      sign_in @user
      redirect_to referer
    end
    # super
  end

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