class Public::BrokersController < ApplicationController
  layout 'pages'
  respond_to :html, :json

  # skip_before_action :authenticate_user!, only:[:index]

  def new
    @broker = Broker.new
  end
end