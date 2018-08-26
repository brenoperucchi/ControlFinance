require 'sidekiq-scheduler'

class ProposalExpiredToRefuseWorker
  include Sidekiq::Worker

  def perform(header={}, metadata)
    Store.all.each do |store|
      store.builds.each do |build|
        build.proposals.expire_to_refuse.each do |proposal|
          mailer = proposal.mailers.new(store: proposal.builder.store, userable: proposal.broker, type: "Mailer::ProposalExpired")
          mailer.prepare
          mailer.delivery
          proposal.refuse
        end
      end
    end
  end
end