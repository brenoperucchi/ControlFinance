# save_and_open_page
require 'rails_helper'

RSpec.describe "PublicProposals" do
  let!(:store) {FactoryGirl.create(:store) }
  let!(:broker) {FactoryGirl.create(:broker, :default, store: store)}
  let!(:build) {FactoryGirl.create(:build, store: store)}
  let!(:unit) { FactoryGirl.create(:unit, builder:build)}
  let!(:proposal) { FactoryGirl.create(:proposal, unit: unit, broker: broker)}
  let!(:buyer) { FactoryGirl.create(:buyer, proposal: proposal)}

  it 'Accepted Redirect to PurchaseStep Proposal' do
    broker.user.make_current
    login_as(broker.user, :scope => :user)
    proposal.accept
    visit public_dashboards_path
    page.first(:xpath, "//a[@href='/public/builds/1/units']").click()
    page.first(:xpath, "//a[@href='/public/units/1/proposals/new']").click()
    expect(page).to have_text('Dear Broker your proposal was accepted!') 
    # expect(page).to have_text('Buyer') 
    # expect(page).to have_text('Document') 
  end

  it 'PurchaseStep Buyer' do
    broker.user.make_current
    login_as(broker.user, :scope => :user)
    proposal.accept
    visit public_dashboards_path
    page.first(:xpath, "//a[@href='/public/builds/1/units']").click()
    page.first(:xpath, "//a[@href='/public/units/1/proposals/new']").click()
    expect(page).to have_text('Dear Broker your proposal was accepted!') 
    click_button('Next Step')
    expect(page).to have_css('li.nav-item a.active span', text: 'Comprador')
  end

  it 'PurchaseStep Document' do
    broker.user.make_current
    login_as(broker.user, :scope => :user)
    proposal.accept
    visit public_dashboards_path
    page.first(:xpath, "//a[@href='/public/builds/1/units']").click()
    page.first(:xpath, "//a[@href='/public/units/1/proposals/new']").click()
    click_button('Next Step')
    fill_in("proposal_buyers_attributes_0_address", with: 'Address')
    click_button('Next Step')
    expect(page).to have_css('li.nav-item a.active span', text: 'Documentos')
  end

end