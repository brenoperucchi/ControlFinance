class Admin::MailersController < Admin::BaseController
  skip_before_action :check_store, only:[:redirect]
  before_action :set_mailer, only:[:new, :create, :notify]
  respond_to :html, :xml, :json, :js
  layout 'pages'

  def notify
    @mailer = "Mailer::#{@param_method.classify}".constantize.new
    respond_with @mailer
  end

  def new
    @mailer = @object.mailers.new(store: current_store, type: "Mailer::#{@param_method.classify}")
    @mailer.prepare
    respond_to do |wants|
      wants.js {}
      wants.html { render @mailer.name }
    end
  end

  # def show
  #   @param_method = params[:method]
  #   @method = "MailerMethod::#{@param_method.classify}".constantize.new
  #   @mailer = Mailer.new(@method.attributes.merge(mailable: @method.object))
  #   respond_to do |format|
  #     format.html { render inline: @mailer.body }
  #   end
  # end

  def create
    @mailer = @object.mailers.new(mailer_params.merge(store: current_store, userable:current_user, type: "Mailer::#{@param_method.classify}"))
    if @mailer.prepare and @mailer.save
      @mailer.delivery
      flash[:notice] = t :notice, scope: 'flash.custom.email_sent'
      redirect_to new_admin_mailer_path(@object.class.name, @object, @mailer.name)
    else
      render template: "admin/mailers/#{@param_method.downcase}.html.slim"
    end
  end

  private

    def set_mailer
      mailable_type = params[:mailable_type]
      @param_method = params[:method]
      @object = current_store.send(mailable_type.pluralize.downcase).find(params[:mailable_id])
      # @method = "MailerMethod::#{param_method.classify}".constantize.new(@object.attributes.delete(:id))    
    end

    def mailer_params
      case params[:method]
      when 'price_list'
        params.require(:mailer_price_list).permit(:method, :subject, :body, :register_user, :store_id, :register_broker, brokers:[], to:[])
      when 'proposal_request'
        params.require(:mailer_proposal_request).permit(:method, :subject, :body, :store_id, :register_broker, :to, :token)
      else
        params.require(:mailer).permit(:method, :subject, :body, :store_id, :register_broker, to:[])
      end
    end

end