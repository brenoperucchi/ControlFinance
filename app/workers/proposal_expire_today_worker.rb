require 'sidekiq-scheduler'

class ProposalExpireTodayWorker
  include Sidekiq::Worker

  def perform()
    Store.all.each do |store|
      store.builds.each do |build|
        build.proposals.expire_today.each do |proposal|
          mailer = proposal.mailers.new(store: proposal.builder.store, userable: proposal.broker, type: "Mailer::ProposalExpireToday")
          mailer.prepare
          mailer.delivery
        end
      end
    end
  end
end