# save_and_open_page
require 'rails_helper'

RSpec.describe "Mailer" do
  let!(:store) { FactoryBot.create(:store) }
  let!(:admin) { FactoryBot.create(:user, :admin, store: store, userable: FactoryBot.create(:person, :admin))}
  let!(:build) { FactoryBot.create(:build, store: store)}
  let!(:unit) { FactoryBot.create(:unit, builder:build)}
  let!(:proposal) { FactoryBot.create(:proposal, unit: unit, broker: FactoryBot.create(:broker, :default))}
  let!(:mailer) { proposal.mailers.new(store: proposal.builder.store, userable: proposal.broker, type: "Mailer::ProposalExpired") }
  # let!(:mail) { ApplicationMailer.dispach(mailer.header) }

  it 'ProposalExpired can deliver mail' do
    proposal.book
    mailer.prepare

    expect{ mailer.delivery }.to change( MailerWorker.jobs, :size ).by(1)
    # expect{ mailer.delivery }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'Send a Price List'  do
    admin.make_current
    login_as(admin, :scope => :user)
    proposal.book
    expect(proposal.state).to match('booked')
    visit admin_builds_path
    click_link('Mail Price List')
    fill_in("mailer_price_list[to][]", with: 'test@test.com')    
    page.first(:css, "#create_price_list").click
    expect(page).to have_css("span#notification-message", text: 'Email sent')
  end

  it 'Price List with present validate'  do
    admin.make_current
    login_as(admin, :scope => :user)
    proposal.book
    expect(proposal.state).to match('booked')
    visit admin_builds_path
    click_link('Mail Price List')
    page.first(:css, "#create_price_list").click
    expect(page).to have_text("can't be blank")
  end


end
