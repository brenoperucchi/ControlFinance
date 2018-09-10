class Admin::ImagesController < ApplicationController
  before_action :set_build, only: [:new, :create, :index]
  respond_to :html, :xml, :json, :js
  # skip_before_action :verify_authenticity_token, :if => Proc.new {|c| c.request.format == 'application/json'}
  protect_from_forgery unless: -> { request.format.json? }


  def index
    # resource = params[:assetable_type].constantize.find(params[:assetable_id])
    @images = @build.images
    respond_to do |wants|
      wants.json { render json: AssetPresenter.new(@images).to_json, status: :ok }
    end
  end

  def new
    @image = @build.images.new
    respond_with @image
    # respond_to do |wants|
    #   wants.json { render json: AssetPresenter.new(@image).to_json, status: :ok }
    # end
  end

  def create
    # @resource = params[:assetable_type].constantize.find(params[:assetable_id])
    # @image = @build.images.new
    @image = @build.images.new(asset_params)
    if @image.save
      respond_to do |format|
        format.json{ render :json => AssetPresenter.new(@image).to_json }
        format.html{ redirect_to admin_builds_path }
      end
    end
  end

  # def update
  #   if @asset.update(asset_params)
  #     respond_to do |format|
  #       format.json{ render :json => AssetPresenter.new(@asset).to_json }
  #       format.html{ redirect_to admin_builds_path }
  #     end
  #   end
  # end
  
  # def destroy
  #   @asset.destroy
  #   respond_to do |wants|
  #     wants.json { render body: nil, status: 200 }
  #   end
  # end


  private
    def set_build
      @build = current_store.builds.find(params[:build_id])
    end

    def asset_params
      params.require(:asset).permit(:file)
    end
end