class Crontab

  def self.proposals_expired_mailer
    Build.all.each do |build|
      build.proposals.expired.each do |proposal|
        method_expired = MailerMethod::ProposalExpired.new(proposal)
        mailer = proposal.mailers.new(method_expired.attributes)
        if mailer.save
          delivery = ApplicationMailer.dispach(mailer.header).deliver
        end
      end
    end
  end

end