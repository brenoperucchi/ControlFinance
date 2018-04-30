class Public::PurchaseStepsController < Public::BaseController
  include Wicked::Wizard
  skip_before_action :authenticate_user!, only:[:show]
  steps :proposal, :buyer, :document, :finish, :finish2, :contract, :print

  layout 'pages'

  before_action :set_parent, only: [:show, :update, :finish]
  respond_to :html, :json

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