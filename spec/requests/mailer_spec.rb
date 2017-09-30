require 'rails_helper'

RSpec.describe "Mailer" do
  let!(:admin) { FactoryGirl.create(:user, :admin, userable: FactoryGirl.create(:person, :admin))}
  let!(:build) { FactoryGirl.create(:build)}
  let!(:unit) { FactoryGirl.create(:unit, builder:build)}
  let!(:proposal) { FactoryGirl.create(:proposal, unit: unit, broker: FactoryGirl.create(:broker, :default))}
  let!(:mailer_method) { MailerMethod::ProposalExpired.new(proposal) }
  let!(:mailer) { proposal.mailers.new(mailer_method.attributes) }
  let!(:mail) { ApplicationMailer.dispach(mailer.header) }


  it 'Admin Can Send Proposal' do
    login_as(admin, :scope => :user)
    visit admin_builds_path
    click_link('Request Proposal Email')
    fill_in("mailer_to", with: 'bperucchi@uol.com.br')    
    click_button('SendMail')
    expect(page).to have_text('Email Sent!')
  end

  it 'ProposalExpired can deliver mail' do
    proposal.book
    expect{ mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    expect(mailer.token).to eq(mailer_method.token)
  end

end