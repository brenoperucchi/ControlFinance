require 'sidekiq-scheduler'

class ExpireTodayWorker
  include Sidekiq::Worker

  def perform(header={}, metadata)
    # Store.all.each do |store|
    #   store.builds.each do |build|
    #     build.proposals.expire_today.each do |proposal|
    #       mailer = proposal.mailers.new(store: proposal.builder.store, userable: proposal.broker, type: "Mailer::ProposalExpireToday")
    #       mailer.prepare
    #       mailer.delivery
    #     end
    #   end
    # end
  end
end

class ExpireDay3Worker
  include Sidekiq::Worker

  def perform(header={}, metadata)
    # Store.all.each do |store|
    #   store.builds.each do |build|
    #     build.proposals.expire_day3.each do |proposal|
    #       mailer = proposal.mailers.new(store: proposal.builder.store, userable: proposal.broker, type: "Mailer::ProposalExpireDay3")
    #       mailer.prepare
    #       mailer.delivery
    #     end
    #   end
    # end
  end
end