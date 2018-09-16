class Public::NotifiesController < Public::BaseController
  before_action :set_belongs_to, only:[:new, :create]
  respond_to :js, :html, :json
  skip_before_action :authenticate_user!, only:[:new]

  def new
    @notify = @object.notifies.new
    respond_with  @notify
  end

  def create
    # @object.notes.create(unit: @object.unit, broker: @object.broker, admin: current_user.userable, comment: notes_params[:comment])
    # redirect_to edit_admin_proposal_path(@object)
    # # TODO Flash Message
  end
  
  private

  def set_belongs_to
    @object = current_store.builds.find(params[:build_id])
  end
  
  def notes_params
    params.require(:note).permit(:comment)
  end
end