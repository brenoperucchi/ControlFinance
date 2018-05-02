class Public::UnitsController < Public::BaseController
  before_action :set_build, only: [:index, :edit, :new, :create, :purchase]
  layout 'pages'
  respond_to :html, :js, :json
  # skip_before_action :authenticate_user!, only:[:index]

  def index
    @proposals = @build.proposals
    @units = @build.units
    respond_with @units
  end

  private

  def set_build
    @build = Build.find(params[:build_id])
  end

end