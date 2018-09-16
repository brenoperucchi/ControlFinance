# class Admin::NotifiesController < Admin::BaseController
#   before_action :set_belongs_to, only:[:new, :create]
#   respond_to :js, :html, :json

#   def new
#     @notify = @object.
#     respond_with  
#   end

#   def create
#     # @object.notes.create(unit: @object.unit, broker: @object.broker, admin: current_user.userable, comment: notes_params[:comment])
#     # redirect_to edit_admin_proposal_path(@object)
#     # # TODO Flash Message
#   end
  
#   private

#   def set_belongs_to
#     @object = current_store.builds.find(params[:build_id])
#   end
  
#   def notes_params
#     params.require(:note).permit(:comment)
#   end
# end