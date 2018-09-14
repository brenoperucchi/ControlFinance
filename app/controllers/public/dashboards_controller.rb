class Public::DashboardsController < Public::BaseController
  skip_before_action :authenticate_user!, only:[:index]

  def index
    @builds = current_store.builds.order('updated_at desc')
  end
end