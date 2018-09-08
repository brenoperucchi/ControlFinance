class Public::BuildsController < Public::BaseController
  # before_action :set_build, only: [:index, :edit, :new, :create, :purchase]
  skip_before_action :authenticate_user!, only:[:sales]
  # layout 'pages/print'
  respond_to :html, :js, :json

  def sales
    @units = current_store.units
    respond_with @units, layout: 'pages/print'
  end

  def option
    @build = current_store.builds.find(params[:id])
    @option = params[:option]
    respond_with @build, layout: 'shards'
  end

  # private
  # def set_build
  #   @build = Build.find(params[:build_id])
  # end
end