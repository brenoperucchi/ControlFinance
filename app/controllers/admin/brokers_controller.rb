class Admin::BrokersController < Admin::BaseController
  layout 'pages'
  before_action :set_admin_broker, only: [:show, :edit, :update, :destroy, :scope, :assets, :deliver_mail, :documents]
  respond_to :js, :html, :json

  def index
    if params[:query][:term]
      @brokers = current_store.brokers.search_by(params[:query][:term])
    else
      @brokers = current_store.try(:brokers) || broker.all
    end
    respond_with @brokers
  end

  def show
  end

  def new
    @broker = current_store.brokers.new
  end

  def assets
    @resource = @broker
    respond_with(@build)    
  end

  def edit
  end

  def create
    @broker = current_store.brokers.new(admin_broker_params)
    @broker.department = 'user'
    @broker.person_type = 'person'
    @broker.validate_off = true
    respond_to do |format|
      if @broker.save
        format.html { redirect_to admin_brokers_path, notice: 'broker was successfully created.' }
        format.json { render :show, status: :created, location: @broker }
        format.js { }
      else
        format.html do
          render :new
        end
        format.json { render json: @broker.errors, status: :unprocessable_entity }
        format.js { }
      end
    end
  end

  def update
    @broker.update(admin_broker_params)
    respond_with @broker, location: admin_brokers_path
  end

  def destroy
    @broker.destroy
    respond_to do |format|
      format.html { redirect_to admin_brokers_url, notice: 'broker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_admin_broker
      @broker = current_store.brokers.find(params[:id])
    end

    def admin_broker_params
      params.require(:broker).permit(:name, :irs_id, :company, :address, :phone, :company_irs_id, :state, :option1, :option2, :option3, :option4, :option5, :store_id, :comment, user_attributes:[:id, :email, :store_id])
    end
end