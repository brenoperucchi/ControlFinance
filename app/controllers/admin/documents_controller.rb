class Admin::DocumentsController < ApplicationController
  before_action :set_document, only: [:destroy, :update]
  respond_to :html, :json

  def update
    if @document.update(document_params)
      respond_with(@proposal)
    end
  end
  
  def destroy
    @document.destroy
    respond_to do |wants|
      wants.json { render body: nil, status: 200 }
    end
  end


  private
    def set_document
      @document = Document.find(params[:id])
    end

    def document_params
      params.require(:document).permit(:status)
    end
end