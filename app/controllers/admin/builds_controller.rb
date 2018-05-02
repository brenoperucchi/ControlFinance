class Admin::BuildsController < Admin::BaseController
  layout 'pages'
  before_action :set_admin_build, only: [:show, :edit, :update, :destroy, :scope, :assets, :deliver_mail]
  respond_to :js, :html, :json


  def deliver_mail
    params_method = params[:method]
    case params_method
    when 'expired'
      @build.proposals.expired.each do |proposal|
        mailer_method = "MailerMethod::Proposal#{params_method.classify}".constantize.new(proposal)
        mailer_method.deliver_mail
      end
    end
    respond_to do |format|
      format.html { redirect_to scope_admin_build_path(@build, scope: params_method.to_sym), notice: 'Emails was successfully delivery.' }
      # format.json { render :show, status: :ok, location: @build }
    end
  end

  def assets
    respond_with(@build)
  end

  def index
    @builds = current_store.try(:builds) || Build.all
  end

  def scope
    if params[:scope] != "proposals"
      @collection = @build.proposals.send(params[:scope]).order('updated_at desc')
    else
      @collection = @build.proposals.order('updated_at desc')
    end
  end

  def show
  end

  def new
    @build = current_store.builds.new
  end

  def edit
  end

  def create
    @build = current_store.builds.new(admin_build_params)

    respond_to do |format|
      if @build.save
        format.html { redirect_to admin_builds_path, notice: 'Build was successfully created.' }
        format.json { render :show, status: :created, location: @build }
        format.js { }
      else
        format.html { render :new }
        format.json { render json: @build.errors, status: :unprocessable_entity }
        format.js { }
      end
    end
  end

  def update
    respond_to do |format|
      if @build.update(admin_build_params)
        format.html { redirect_to [:edit, :admin, @build], notice: 'Build was successfully updated.' }
        format.json { render :show, status: :ok, location: @build }
      else
        format.html { render :edit }
        format.json { render json: @build.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @build.destroy
    respond_to do |format|
      format.html { redirect_to admin_builds_url, notice: 'Build was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_admin_build
      @build = current_store.builds.find(params[:id])
    end

    def admin_build_params
      params.require(:build).permit(:name, :state, :address, :registry, :incorporation)
    end
end