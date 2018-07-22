class Crontab

  def self.proposals_expired_mailer
    Build.all.each do |build|
      build.proposals.expired.each do |proposal|
        mailer = proposal.mailers.new(store: proposal.builder.store, userable: proposal.broker, type: "Mailer::ProposalExpired")
        mailer.prepare
        mailer.delivery
      end
    end
  end

end