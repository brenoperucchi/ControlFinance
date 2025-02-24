class Public::ProposalsController < Public::BaseController
  layout 'shards'
  # skip_before_action :authenticate_user!, only:[:create, :update, :destroy, :expired]
  before_action :broker_set, except: [:comment, :expired]
  before_action :proposal_set, only: [:show, :edit, :update, :destroy, :comment, :invoice]
  before_action :init_of_params, only: [:index, :create, :booking]
  before_action :init_of_proposal, only: [:edit, :update, :comment, :redirect_if_proposal_bought, :invoice, :destroy]
  # before_action :init_activities, only: [:document, :edit, :update]
  before_action :redirect_if_proposal_bought, except: [:new, :comment, :expired, :invoice]
  before_action :redirect_if_broker_config_set, except: [:new, :comment, :expired, :invoice]
  respond_to :html, :json, :js
  skip_before_action :authenticate_user!, only:[:new]

  def invoice
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
    # @activities_broker = @unit.activities_broker(@broker).order('created_at desc')_
    ## MENTORIA
    # @broker = current_user.userable
    # @notes = @broker.notes.where(unit: @unit).order('created_at desc')
    # @proposals = @broker.proposals.where(unit: @unit)
    @build = current_store.builds.find(params[:build_id])
    @units = @build.units
    @proposal = @build.proposals.new
    @proposal.due_at = Date.today.strftime("%d/%m/%Y")
    @proposal.broker = @broker
    render :new, layout: 'shards'
  end

  # def edit
  #   respond_with(@proposal)
  # end

  def create
    @build = current_store.builds.find(params[:build_id])
    @units = @build.units
    @proposal = @build.proposals.new(proposal_params)
    @proposal.brokerage = @unit.brokerage
    @proposal.broker = @broker
    # sign_in @proposal.broker.user if @proposal.try(:broker).try(:user).try(:persisted?)
    if not @proposal.unit.bought?
      if @proposal.save
        respond_with @proposal, location: invoice_public_proposal_path(@proposal)
      else
        @notes = @broker.notes.where(unit: @unit).order('created_at desc')
        respond_with @proposal
      end
    else
      redirect_if_proposal_bought
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
      flash[:alert] = t(:proposal_restricted, scope:'errors.custom')
      respond_with @proposal 
    end
  end

  def destroy
    build = @proposal.unit.builder
    if @proposal.destroy
      respond_with @proposal, location: public_store_builds(build)
    else
      respond_with @proposal
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
      if @unit.proposal_bought.present?
        proposal = @unit.proposal_bought
        if current_user.try(:userable).is_a?(Broker) and proposal.broker == @broker
          if proposal.try(:accepted?)
            redirect_to public_purchase_steps_path(proposal)
          elsif proposal.try(:closed?)
            redirect_to finish_public_purchase_steps_path(proposal)
          end
        else
          redirect_to public_store_builds(@unit.builder), alert: t(:proposal_restricted, scope:'errors.custom')
        end
      elsif @unit.bought?
        redirect_to public_store_builds(@unit.builder), alert: t(:proposal_restricted, scope:'errors.custom')
      end
    end

    def resource
      current_store.proposals
    end

    # def init_activities
    #   @activities = @proposal.activities.order('created_at desc')
    # end

    def broker_set
      @broker = current_user.try(:userable) if current_user.try(:userable).is_a?(Broker)
    end

    def proposal_set
      @name_space = :public
      @proposal = Proposal.find(params[:id])
    end

    def init_of_params
      # @unit = Unit.find(params[:unit_id])
      # @build = @unit.builder
      @build = current_store.builds.find(params[:build_id])
      @unit = current_store.units.find(proposal_params[:unit_id])
    end

    def init_of_proposal
      @unit = @proposal.unit
      @build = @unit.builder
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proposal_params
      delocalize_config = { :value => :number }
      params.require(:proposal).permit(:state, :name, :negociate, :value, :comment, :due_at, :unit_id,
                                       broker_attributes:[:id, :name, user_attributes:[:id, :email]],
                                       buyers_attributes:[:id, :name]).delocalize(delocalize_config)
    end
end
