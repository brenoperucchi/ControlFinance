class Admin::StoresController < Admin::BaseController
  layout 'pages'
  before_action :set_admin_store
  respond_to :js, :html, :json

  def edit
    respond_with @store
  end

  def update
    if @store.update(admin_store_params)
      respond_with @store, location: edit_admin_store_path
    else
      respond_with @store
    end
  end

  private
    def set_admin_store
      @store = current_store
    end

    def admin_store_params
      params.require(:store).permit(:broker_config, :language, :address, :phone, :email, :name, :url)
    end
end