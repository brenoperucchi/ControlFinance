# save_and_open_page
require 'rails_helper'

RSpec.describe "Mailer" do
  let!(:store) { FactoryGirl.create(:store) }
  let!(:admin) { FactoryGirl.create(:user, :admin, store: store, userable: FactoryGirl.create(:person, :admin))}
  let!(:build) { FactoryGirl.create(:build, store: store)}
  let!(:unit) { FactoryGirl.create(:unit, builder:build)}
  let!(:proposal) { FactoryGirl.create(:proposal, unit: unit, broker: FactoryGirl.create(:broker, :default))}
  let!(:mailer) { proposal.mailers.new(store: proposal.builder.store, userable: proposal.broker, type: "Mailer::ProposalExpired") }
  # let!(:mail) { ApplicationMailer.dispach(mailer.header) }

  it 'ProposalExpired can deliver mail' do
    proposal.book
    mailer.prepare
    expect{ mailer.delivery }.to change { ActionMailer::Base.deliveries.count }.by(1)
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