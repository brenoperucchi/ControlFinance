class Public::UnitsController < Public::BaseController
  before_action :set_build, only: :index
  respond_to :html, :js, :json
  # include RestrictStore
  # restrict_store :build
  skip_before_action :authenticate_user!, only:[:index]

  def index
    @proposals = @build.proposals
    @units = @build.units
    respond_with @units
  end

  private

  def set_build
    @build = current_store.builds.find_by_id(params[:build_id])
  end

end