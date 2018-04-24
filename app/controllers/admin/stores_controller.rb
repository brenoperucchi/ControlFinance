class Admin::StoresController < Admin::BaseController
  layout 'pages'
  before_action :set_admin_store
  respond_to :js, :html, :json

  def edit
  end

  def update
    respond_to do |format|
      if @store.update(admin_store_params)
        format.html { redirect_to edit_admin_store_path, notice: 'store was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @store] }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def set_admin_store
      @store = current_store
    end

    def admin_store_params
      params.require(:store).permit(:broker_config, :language, :address, :phone, :email)
    end
end