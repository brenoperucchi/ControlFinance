class MailerWorker
  include Sidekiq::Worker

  def perform(header={})
    ApplicationMailer.dispach(header).deliver_now
  end

end