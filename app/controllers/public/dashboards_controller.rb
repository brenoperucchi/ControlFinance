class Public::DashboardsController < Public::BaseController
  layout 'pages'
  skip_before_action :authenticate_user!, only:[:index]

  def index
    @builds = current_store.try(:builds) || Build.all
  end
end