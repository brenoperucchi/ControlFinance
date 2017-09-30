class Admin::ProposalsController < Admin::BaseController
  before_action :set_proposal, only: [:update, :edit, :comment, :email, :document, :action]
  before_action :belongs_to_params, only: [:index, :new, :create]
  before_action :belongs_to_persited, only: [:edit, :update, :comment]
  # before_action :collection, only: [:create, :update]
  before_action :set_activities, only: [:document, :comment, :edit]
  respond_to :html, :xml, :json, :js

  # /Custom Action

  def comment
    respond_to do |format|
      if @proposal.update(proposal_params)
        format.html { redirect_to edit_admin_proposal_path(@proposal), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @proposal }
      else
        format.html { render :edit }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  def action
    action = params[:act]  
    @proposal.documents.find_by_id(params[:document_id]).send(action)
    respond_with(@proposal)
  end

  def document
    respond_with(@proposal) #, layout:'common/chat')
  end

  # /Custom Action

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
    respond_with(@proposal) #, layout:'common/chat')
  end

  def create
    @proposal = Admin::Proposal.new(proposal_params)
    respond_to do |format|
      if @proposal.save
        @activities = @proposal.activities.order('created_at desc')
        format.html { redirect_to [:edit, @proposal], notice: 'Proposal was successfully created.' }
        format.json { render :show, status: :created, location: @proposal }
      else
        @activities = @proposal.activities.order('created_at desc')
        format.html { render :new }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @proposal.update(proposal_params)
        @activities = @proposal.activities.order('created_at desc')
        format.html { redirect_to [:edit, @proposal], notice: 'Proposal was successfully updated.' }
        format.json { render json: @proposal }
      else
        @activities = @proposal.activities.order('created_at desc')
        format.html { render :edit }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @proposal.destroy
    respond_to do |format|
      format.html { redirect_to proposals_url, notice: 'Proposal was successfully destroyed.' }
      format.json { head :no_content }
    end
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
      params.require(:admin_proposal).permit(:unit_id, :status, :name, :negociate, :value, :comment, :due_at, :brokerage, 
                            documents_attributes:[:id, :name, :approved_at, :_destroy],
                            broker_attributes:[:id, :name, user_attributes:[:id, :email]])


    end
end
