class Admin::ProposalsController < Admin::BaseController
  before_action :set_proposal, only: [:update, :edit, :comment, :invoice, :email, :document, :action]
  before_action :belongs_to_params, only: [:index, :new, :create]
  before_action :belongs_to_persited, only: [:edit, :update, :comment, :invoice]
  # before_action :collection, only: [:create, :update]
  before_action :set_activities, only: [:document, :comment, :invoice, :edit]
  respond_to :html, :xml, :json, :js

  # /Custom Action


  def invoice
    respond_with @proposal, layout: 'pages/admin/print'
  end

  def comment
    if @proposal.update(proposal_params)
      respond_with @proposal, location: edit_admin_proposal_path(@proposal)
    else
      respond_with @proposal
    end
  end

  def action
    action = params[:act]  
    @proposal.documents.find_by_id(params[:document_id]).send(action)
    respond_with @proposal
  end

  def document
    respond_with @proposal #, layout:'common/chat')
  end

  def index
    @collection = @unit.admin_proposals
  end

  def show
  end

  def new
    @proposal = Admin::Proposal.new(unit:@unit, brokerage: @unit.brokerage)
  end

  def edit
    @proposals = Proposal.all
    respond_with @proposal #, layout:'common/chat')
  end

  def create
    @proposal = Admin::Proposal.new(proposal_params)
    if @proposal.save
      @activities = @proposal.activities.order('created_at desc')
      respond_with @proposal, location: [:edit, @proposal]
    else
      @activities = @proposal.activities.order('created_at desc')
      respond_with @proposal
    end
  end

  def update
    if @proposal.update(proposal_params)
      @activities = @proposal.activities.order('created_at desc')
      respond_with @proposal, location: [:edit, @proposal]
    else
      @activities = @proposal.activities.order('created_at desc')
      respond_with @proposal
    end
  end

  def destroy
    @proposal.destroy
    respond_with @proposal, location: admin_proposals_path
  end

  private

    def set_activities
      @activities = @proposal.activities.order('created_at desc')
    end

    def set_proposal
      @name_space = nil
      @proposal = Admin::Proposal.find(params[:id])
    end

    def belongs_to_params
      @unit = Unit.find_by_id(params[:unit_id]) || @proposal.unit
      @build = @unit.builder
    end

    def belongs_to_persited
      @unit = @proposal.unit
      @build = @unit.builder
    end

    # def collection
    #   @proposals = resource
    # end

    def proposal_params
      params.require(:admin_proposal).permit(:unit_id, :states, :name, :negociate, :value, :comment, :due_at, :brokerage, :broker_id, 
                            documents_attributes:[:id, :name, :approved_at, :_destroy],
                            broker_attributes:[:id, :name, user_attributes:[:id, :email]])
    end
end