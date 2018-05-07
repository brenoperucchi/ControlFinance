class Public::PurchaseStepsController < Public::BaseController
  include Wicked::Wizard
  layout 'pages'

  skip_before_action :authenticate_user!, only:[:show]
  before_action :set_parent, only: [:show, :update, :finish, :restrict_proposal]
  before_action :restrict_proposal, only:[:show]
  respond_to :html, :json
  
  steps :proposal, :buyer, :document, :finish, :finish2, :contract, :print

  def show 
    @activities = @proposal.activities.order('created_at desc')
    @unit = @proposal.unit
    @assets = @proposal.assets
    case step
    when :finish2
      render :finish2, layout: false
    when :finish
      render :finish
      ApplicationMailer.dispach({to: @proposal.broker.user.email, subject: "#{@proposal.unit.name}: Proposal Finished", body: render_to_string(:finish2, layout:false)}).deliver
    when :contract
      render :contract, layout: 'pages/print'
    when :print
      render html: render_to_string('_finish.html.slim', layout:'pages/print')
    else
      render_wizard
    end
  end

  def update
    case step
    when :proposal
      respond_with @proposal, location: wizard_path(:buyer)
    when :buyer
      @proposal.is_validate = true
      if @proposal.update(proposal_params)
        respond_with @proposal, location: wizard_path(:document)
      else
        @activities = @proposal.activities.order('created_at desc')
        render :buyer
      end
    when :document
      if @proposal.save
        redirect_to wizard_path(:finish)
      else
        respond_with @proposal
      end
    end
  end  

  private

  def restrict_proposal
    redirect_to(public_dashboards_path, alert: t(:proposal_user_not_allowed, scope:'errors.custom')) if @proposal.broker != current_user.try(:userable) 
  end
   
   def set_parent
    @name_space = :public
    @proposal = Proposal.find(params[:proposal_id])
   end 

   def proposal_params
     params.require(:proposal).permit(
         buyers_attributes:[:id, :name, :irs_id, :national_id, :birthdate, :occupation, :income, :address, :email]
          # broker_attributes:[:id, :name, user_attributes:[:id, :email]],
          # addresses_attributes:[:id, :name, :street, :complement, :city, :country, :state, :zip_code, :phone],
          # asset_attributes:[:id, :file]]
         )
   end
end