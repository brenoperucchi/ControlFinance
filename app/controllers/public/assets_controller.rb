class Public::AssetsController < ApplicationController
  before_action :set_asset, only: [:destroy]
  # respond_to :html, :xml, :json
  # skip_before_action :verify_authenticity_token, :if => Proc.new {|c| c.request.format == 'application/json'}
  protect_from_forgery unless: -> { request.format.json? }

  def index
    resource = params[:assetable_type].constantize.find(params[:assetable_id])
    @assets = resource.assets
    respond_to do |wants|
      wants.json { render json: AssetPresenter.new(@assets).to_json, status: :ok }
    end
  end

  def create
    @resource = params[:assetable_type].constantize.find(params[:assetable_id])
    @asset = @resource.assets.new(asset_params)
    if @asset.save
      respond_to do |format|
        format.json{ render :json => AssetPresenter.new(@asset).to_json }
      end
    end
  end
  
  def destroy
    @asset.destroy
    respond_to do |wants|
      wants.json { render body: nil, status: 200 }
    end
  end


  private
    def set_asset
      @asset = Asset.find(params[:id])
    end

    def asset_params
      params.require(:asset).permit(:file)
    end
end