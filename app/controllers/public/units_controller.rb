class Public::UnitsController < Public::BaseController
  before_action :set_build, only: :index
  respond_to :html, :js, :json
  # include RestrictStore
  # restrict_store :build
  skip_before_action :authenticate_user!, only:[:index]

  def index
    @proposals = @build.proposals
    @units = @build.units
    # @broker = current_user.userable
    # @notes = @broker.notes.where(unit: @unit).order('created_at desc')
    # @proposals = @broker.proposals.where(unit: @unit)
    @proposal = @build.proposals.new
    @proposal.due_at = Date.today.strftime("%d/%m/%Y")
    @proposal.broker = @broker
    respond_with @units
  end

  private

  def set_build
    @build = current_store.builds.find_by_id(params[:build_id])
  end

end