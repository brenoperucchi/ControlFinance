class Site::RegistersController < ApplicationController
  layout 'site'
  respond_to :html, :json

  def new
    @store = Store.new
    respond_with @store
  end

  def create
    @store = Store.new(store_params)  
    if @store.save
      sign_in @store.persons.first.user
      respond_with(@store, location: admin_builds_path)
    else
      respond_with(@store)
    end
  end

  private
    def store_params
      params.require(:store).permit(:name, :terms, persons_attributes:[:name, :department, :person_type, user_attributes: [:email, :password]])
    end

end