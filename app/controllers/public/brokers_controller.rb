class Public::BrokersController < Public::BaseController
  skip_before_action :authenticate_user!, only:[:new, :create, :update, :revise]
  before_action :set_public_broker, only: [:contract, :revise, :update, :assets]
  respond_to :html, :json, :js

  def assets
    @resource = @broker
    respond_with @broker
  end

  def contract
    respond_with(@broker, layout:'layouts/pages/print')
  end

  def revise
    respond_with(@broker, layout:'layouts/pages/broker')
  end

  def new
    @broker = Broker.new(user_attributes:{email:params[:email]})
    render :new, layout:'layouts/pages/broker'
  end

  def create
    @broker = Broker.new(public_broker_params)
    @broker.department = 'user'
    @broker.person_type = 'person'
    if @broker.save
      respond_with @broker, location: revise_public_broker_path(@broker), layout:'layouts/pages/broker'
    else
      respond_with @broker, render:{ action: :new, layout:'layouts/pages/broker' }
    end
    #   respond_to do |format|
    #   if @broker.save
    #     flash[:notice] = "Broker was successfully created."
    #     sign_in @broker.user
    #     format.html { redirect_to revise_public_broker_path(@broker)}
    #     format.json { render :show, status: :created, location: @broker }
    #     format.js {  }
    #   else
    #     flash[:alert] = "Double check your form before continuing."
    #     format.html { render :new}
    #     format.json { render json: @broker.errors, status: :unprocessable_entity }
    #     format.js {  }
    #   end
    # end
  end

  def update
    respond_to do |format|
      if @broker.update(public_broker_params)
        format.html { redirect_to revise_public_broker_path(@broker), notice: 'Information was successfully updated.' }
        format.json { render :show, status: :ok, location: [:public, @broker] }
      else
        format.html { render :document }
        format.json { render json: @broker.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /admin/brokers/1
  # # DELETE /admin/brokers/1.json
  # def destroy
  #   @broker.destroy
  #   respond_to do |format|
  #     format.html { redirect_to admin_builds_path, notice: 'Unit was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private

    def set_public_broker
      @broker = Broker.find(params[:id])
    end

    def public_broker_params
      params.require(:broker).permit(:name, :irs_id, :company, :option1, :option2, :option3, :option4, :option5, :option6, :address, :phone, :company_irs_id, :store_id, :comment, user_attributes:[:id, :email, :store_id])
    end
end