class Public::BuildsController < Public::BaseController
  skip_before_action :authenticate_user!, only:[:index]

  def index
    @builds = Build.all
  end
end