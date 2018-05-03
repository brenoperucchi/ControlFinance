class Public::BuildsController < Public::BaseController
  # before_action :set_build, only: [:index, :edit, :new, :create, :purchase]
  skip_before_action :authenticate_user!, only:[:index]
  layout 'pages/print'
  respond_to :html, :js, :json

  def sales
    @units = current_store.units
    respond_with @units
  end

  # private
  # def set_build
  #   @build = Build.find(params[:build_id])
  # end
end