class Public::UnitsController < Public::BaseController
  before_action :set_build, only: [:index, :edit, :new, :create, :purchase]
  layout 'pages'
  # skip_before_action :authenticate_user!, only:[:index]

  def index
    @units = @build.units
  end

  private

  def set_build
    @build = Build.find(params[:build_id])
  end

end