class Admin::NotesController < Admin::BaseController
  before_action :set_belongs_to

  def create
    @object.notes.create(unit: @object.unit, broker: @object.broker, admin: current_user.userable, comment: notes_params[:comment])
    redirect_to edit_admin_proposal_path(@object)
    # TODO Flash Message
  end
  
  private

  def set_belongs_to
    @object = Admin::Proposal.find(params[:proposal_id])
  end
  
  def notes_params
    params.require(:note).permit(:comment)
  end
end