require 'sidekiq-scheduler'

class ProposalExpireDay3Worker
  include Sidekiq::Worker

  def perform()
    Store.all.each do |store|
      store.builds.each do |build|
        build.proposals.expire_day3.each do |proposal|
          mailer = proposal.mailers.new(store: proposal.builder.store, userable: proposal.broker, type: "Mailer::ProposalExpireDay3")
          mailer.prepare
          mailer.delivery
        end
      end
    end
  end
end