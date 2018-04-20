class Public::ProposalsController < Public::BaseController
  layout 'pages'
  # skip_before_action :authenticate_user!, only:[:create, :update, :destroy, :expired]
  before_action :broker_set, except: [:comment, :expired]
  before_action :proposal_set, only: [:show, :edit, :update, :destroy, :comment, :print]
  before_action :init_of_params, only: [:index, :new, :create, :booking]
  before_action :init_of_unit, only: [:edit, :update, :comment, :redirect_if_proposal_bought, :print]
  before_action :init_activities, only: [:document, :edit, :update]
  before_action :redirect_if_proposal_bought, except: [:comment, :expired]
  before_action :redirect_if_broker_config_set, except: [:comment, :expired]
  respond_to :html, :json, :js

  def print
    respond_with @proposal, layout: 'pages/print'
  end

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
    @proposals = @broker.proposals.where(unit: @unit)
    @proposal = @unit.proposals.new
    @proposal.due_at = Date.today.strftime("%d/%m/%Y")
    @proposal.broker = @broker
    render :new
  end

  def edit
    respond_with(@proposal)
  end

  def create
    @proposal = @unit.proposals.new(proposal_params)
    @proposal.brokerage = @unit.brokerage
    @proposal.broker = @broker
    # sign_in @proposal.broker.user if @proposal.try(:broker).try(:user).try(:persisted?)
    if not @proposal.unit.bought?
      if @proposal.save
        MailerMethod::ProposalCreate.new(@proposal).deliver_mail
        respond_with @proposal, location: print_public_proposal_path(@proposal)
      else
        respond_with @proposal
      end
    else
      redirect_if_restriction
    end
  end

  def update
    if not @proposal.unit.bought? and not @proposal.booked?
      if @proposal.update(proposal_params)
        respond_with @proposal, location: public_unit_proposals_path(@proposal.unit)
      else
        respond_with @proposal
      end
    else
      flash[:notice] = t(:proposal_restricted, scope:'errors.custom')
      respond_with @proposal 
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

    def redirect_if_broker_config_set
      if not ActiveModel::Type::Boolean.new.cast(current_store.broker_config) and not @broker.approved?
        respond_to do |format|
          format.html { redirect_to revise_public_broker_path(@broker) }
          format.js { render :js => "window.location.href='"+revise_public_broker_path(@broker)+"'" }
        end
      end
    end

    def redirect_if_proposal_bought
      return true unless @unit.proposal_bought.present?
      proposal = @unit.proposal_bought
      if current_user.try(:userable).is_a?(Broker) and proposal.broker == @broker
        if proposal.try(:accepted?)
          redirect_to public_purchase_steps_path(proposal)
        elsif proposal.try(:closed?)
          redirect_to finish_public_purchase_steps_path(proposal)
        end
      else
        redirect_to public_build_units_path(@unit.builder), notice: t(:proposal_restricted, scope:'errors.custom')
      end
    end

    def resource
      current_store.proposals
    end

    def init_activities
      @activities = @proposal.activities.order('created_at desc')
    end

    def broker_set
      @broker = current_user.try(:userable) if current_user.try(:userable).is_a?(Broker)
    end

    def proposal_set
      @name_space = :public
      @proposal = Proposal.find(params[:id])
    end

    def init_of_params
      @unit = Unit.find(params[:unit_id])
      @build = @unit.builder
    end

    def init_of_unit
      @unit = @proposal.unit
      @build = @unit.builder
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proposal_params
      params.require(:proposal).permit(:state, :name, :negociate, :value, :comment, :due_at,
                                       broker_attributes:[:id, :name, user_attributes:[:id, :email]],
                                       buyers_attributes:[:id, :name])
    end
end
