class Public::ProposalsController < Public::BaseController

  skip_before_action :authenticate_user!, only:[:create, :update, :destroy, :expired]

  before_action :set_proposal, only: [:show, :edit, :update, :destroy, :comment]
  before_action :belongs_to_params, only: [:index, :new, :create, :booking]
  before_action :belongs_to_persited, only: [:edit, :update, :comment, :redirect_if_restriction]
  before_action :redirect_if_restriction, except: [:comment, :expired]
  before_action :set_activities, only: [:document, :edit, :update]
  respond_to :html, :json, :js

  def booking
    @proposal = @unit.proposals.new
    respond_with(@proposal)
  end

  def expired
    render 'expired', layout:false
  end

  def index
    @proposals = @broker.proposals.where(unit: @unit)
    respond_with(@proposals)
  end

  def show
  end

  def new
    @proposal = @unit.proposals.new
    @proposal.due_at = Date.today.strftime("%d/%m/%Y")
    @proposal.broker = @broker
    render :new, layout: 'elite'
  end

  def edit
    respond_with(@proposal)
  end

  def create
    @proposal = @unit.proposals.new(proposal_params)
    @proposal.brokerage = @unit.brokerage
    sign_in @proposal.broker.user if @proposal.try(:broker).try(:user).try(:persisted?)
    if not @proposal.unit.restricted?
      respond_to do |format|
        if @proposal.save
          MailerMethod::ProposalCreate.new(@proposal).deliver_mail
          format.html { redirect_to public_unit_proposals_path(@unit), notice: 'Proposal was successfully created.' }
          format.json { render :show, status: :created, location: @proposal }
          format.js { } 
        else
          format.html { render :new}
          format.json { render json: @proposal.errors, status: :unprocessable_entity }
          format.js { } 
        end
      end
    else
      redirect_if_restriction
    end
  end

  def update
    respond_to do |format|
      if not @proposal.unit.restricted? and not @proposal.booked?
        if @proposal.update(proposal_params)
          format.html { redirect_to edit_public_proposal_path(@proposal), notice: 'Proposal was successfully updated.' }
          format.json { render :show, status: :ok, location: @proposal }
          format.js { } 
        else
          format.html { render :edit }
          format.json { render json: @proposal.errors, status: :unprocessable_entity }
          format.js { } 
        end
      else
        format.html do
          flash[:notice] = t(:proposal_restricted, scope:'errors.custom')
          render :edit 
        end
        format.js { } 
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    build = @proposal.unit.builder
    if @proposal.destroy
      respond_to do |format|
        format.html { redirect_to public_build_units_path(build), notice: 'Proposal was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { render :index } 
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
        format.js { } 
      end
    end
  end

  ### CUSTOM 
  ## COMMENT
  def comment
    @activities = @proposal.activities.order('created_at desc')
    respond_to do |format|
      if @proposal.update(proposal_params)
        format.html { redirect_to edit_public_proposal_path(@proposal), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @proposal }
      else
        format.html { render :edit }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def redirect_if_restriction
      @broker = current_user.try(:userable) if user_signed_in? and current_user.try(:userable).is_a?(Broker)
      if @broker.pending?
        respond_to do |format|
          format.html { redirect_to revise_public_broker_path(@broker) }
          format.js { render :js => "window.location.href='"+revise_public_broker_path(@broker)+"'" }
        end
        return false
      end
      if user_signed_in?
        redirect_to public_purchase_steps_path(@broker.restricted, :proposal) if @unit.restricted? and @broker.try(:restricted) == @unit.restricted
      end
      if @unit.restricted? and @broker.try(:restricted) != @unit.restricted
        redirect_to public_build_units_path(@unit.builder), notice: t(:proposal_restricted, scope:'errors.custom')
      end
    end

    def resource
      current_store.proposals
    end

    def set_activities
      @activities = @proposal.activities.order('created_at desc')
    end

    def set_proposal
      @name_space = :public
      @proposal = Proposal.find(params[:id])
    end

    def belongs_to_params
      @unit = Unit.find(params[:unit_id])
      @build = @unit.builder
    end

    def belongs_to_persited
      @unit = @proposal.unit
      @build = @unit.builder
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proposal_params
      params.require(:proposal).permit(:state, :name, :negociate, :value, :comment, :due_at, broker_attributes:[:id, :name, user_attributes:[:id, :email]])
    end
end
