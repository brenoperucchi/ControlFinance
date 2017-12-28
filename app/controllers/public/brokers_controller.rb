class Public::BrokersController < Public::BaseController
  layout 'pages'

  skip_before_action :authenticate_user!, only:[:new, :create, :update]
  before_action :set_public_broker, only: [:contract, :document, :update]
  respond_to :html, :json

  def contract
    respond_to do |format|
      format.html do
        render :contract
      end
    end
  end

  def document
    respond_to do |format|
      format.html do
        render :document
      end
    end
  end

  def new
    @broker = Broker.new
  end

  def create
    @broker = Broker.new(public_broker_params)
      respond_to do |format|
      if @broker.save
        flash[:info] = "Broker was successfully created."
        "sdsd"
        sign_in @broker.user
        format.html { redirect_to document_public_broker_path(@broker)}
        format.json { render :show, status: :created, location: @broker }
        format.js {  }
      else
        flash[:warning] = "Double check your form before continuing."
        format.html { render :new}
        format.json { render json: @broker.errors, status: :unprocessable_entity }
        format.js {  }
      end
    end
  end

  def update
    respond_to do |format|
      if @broker.update(public_broker_params)
        format.html { redirect_to document_public_broker_path(@broker), notice: 'Information was successfully updated.' }
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
    # Use callbacks to share common setup or constraints between actions.

    def set_public_broker
      @broker = Broker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def public_broker_params
      params.require(:broker).permit(:name, :irs_id, :company, :option1, :option2, :option3, :option4, :option5, :address, :phone, :company_irs_id, :store_id, :comment, user_attributes:[:id, :email, :store_id])
    end
end
