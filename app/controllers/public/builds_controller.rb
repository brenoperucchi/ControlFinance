class Public::BuildsController < Public::BaseController
  layout 'pages'

  def index
    @builds = current_store.try(:builds) || Build.all
  end
end