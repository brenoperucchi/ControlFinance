class MailersController < ApplicationController
  before_action :set_mailer, only:[:new, :create]
  respond_to :html, :xml, :json
  layout 'elite'

  def new
    @mailer = @object.mailers.new(@method.attributes)
    respond_to do |wants|
      wants.html { render @method.name }
    end
  end

  def show
    param_method = params[:method]
    @method = "MailerMethod::#{param_method.classify}".constantize.new
    @mailer = Mailer.new(@method.attributes.merge(mailable: @method.object))
    respond_to do |format|
      format.html { render inline: @mailer.body }
    end
  end

  def create
    @mailer = @object.mailers.new(mailer_params)
    if @mailer.save
      # @mailer.update_attributes(@method.attributes.merge(mailer_params))
      @mailer.update_attributes(@method.attributes.merge(to:params[:mailer][:to], subject:params[:mailer][:subject], body:params[:mailer][:body], token:params[:mailer][:token]))
      delivery = ApplicationMailer.dispach(@mailer.header).deliver
      flash[:notice] = "Email Sent!"
      respond_with(@mailer, location: new_mailer_path(@object.class.name, @mailer.mailable, @method.name))
    else
      render @method.name
    end
  end

  def redirect
    @mailer = Mailer.find_by_token(params[:token])
    @method = "MailerMethod::#{@mailer.method_name.classify}".constantize.new(@mailer.mailable)
    sign_in @mailer.userable.user if @method.signed_in?
    redirect_to @mailer.url
  end

  private

    def set_mailer
      klass = params[:mailable_type]
      param_method = params[:method]
      @object = klass.classify.constantize.find(params[:mailable_id])
      @method = "MailerMethod::#{param_method.classify}".constantize.new(@object)
      
    end

    def mailer_params
      params.require(:mailer).permit(:to, :subject, :body, :token, :mailers)
    end

end