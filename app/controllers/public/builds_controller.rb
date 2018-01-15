class Public::BuildsController < Public::BaseController
  layout 'pages'

  def index
    @builds = current_store.try(:builds) || Build.all
    respond_to do |format|
      format.html { render :index }
      format.js { render :index }
    end
  end
end