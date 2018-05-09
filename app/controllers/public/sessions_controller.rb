class Public::SessionsController < Devise::SessionsController
  include SentientStoreController

  skip_before_action :require_no_authentication, only:[:create]

  layout 'pages/empty'

  def after_sign_in_path_for(resource)
    !current_user.userable.admin? ? public_dashboards_path : admin_builds_path
  end

  def after_sign_out_path_for(resource)
    public_dashboards_path
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    @resource = resource_class.new(sign_in_params)
    # super
  end

  # POST /resource/sign_in
  def create
    email = params[:user][:email]
    @resource = resource_class.new(sign_in_params)
    # @resource.validate_off = true
    # referer = stored_location_for(resource) || request.referer || root_path
    user = User.where(email: email , store: current_store).take
    if not @resource.valid?
      render :new
    elsif user.nil?
      redirect_to(new_public_broker_path(email: email), alert: I18n.t(:unauthenticated_email, scope: 'devise.failure')) 
    elsif user.userable.admin?
      redirect_to admin_new_session_path, alert: I18n.t(:unauthenticated, scope: 'devise.failure')
    else
      sign_in user
      redirect_to public_dashboards_path, notice: I18n.t(:signed_in, scope: 'devise.sessions')
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