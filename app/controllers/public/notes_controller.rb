class Public::NotesController < Public::BaseController
  before_action :set_belongs_to

  def create
    notes = @broker.notes.create(unit: @unit, broker: @broker, comment: notes_params[:comment])
    redirect_to new_public_unit_proposal_path(@unit)
    # TODO Flash Message
  end
  
  private

  def set_belongs_to
    @unit = current_store.units.find(params[:unit_id])
    @broker = current_store.brokers.find(params[:broker_id])
  end
  
  def notes_params
    params.require(:note).permit(:comment)
  end
end