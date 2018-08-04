# save_and_open_page
require 'rails_helper'

RSpec.describe "PublicProposals" do
  let!(:store) {FactoryGirl.create(:store) }
  let!(:broker) {FactoryGirl.create(:broker, :default, store: store)}
  let!(:broker2) {FactoryGirl.create(:broker, :second, store: store)}
  let!(:build) {FactoryGirl.create(:build, store: store)}
  let!(:unit) {FactoryGirl.create(:unit, builder:build)}
  let!(:proposal) {FactoryGirl.create(:proposal, unit: unit, broker: broker)}
  let!(:proposal2) {FactoryGirl.create(:proposal, unit: unit, broker: broker2)}

  before(:each) do
  end

  it 'Make Proposal' do
    login_as(broker.user, :scope => :user)
    visit public_dashboards_path
    page.first(:xpath, "//a[@href='/public/builds/1/units']").click()
    page.first(:xpath, "//a[@href='/public/units/1/proposals/new']").click()
    fill_in("proposal_negociate", with: 'Proposal Negociate')
    fill_in("proposal_value", with: '100')    
    click_button 'Create Proposals'
    expect(page).not_to have_css("span#notification-message", text: 'Please review the problems below')
    expect(page).to have_css("span#notification-message", text: 'Proposals was successfully created.')
    
  end

  it 'User must have sign in' do
    # broker.user.make_current
    # login_as(broker.user, :scope => :user)
    visit public_dashboards_path
    page.first(:xpath, "//a[@href='/public/builds/1/units']").click()
    page.first(:xpath, "//a[@href='/public/units/1/proposals/new']").click()
    expect(current_path).to match(new_user_session_path)
    # save_and_open_page
  end

  it 'Broker can print old Proposals' do
    login_as(broker.user, :scope => :user)
    visit public_dashboards_path
    page.first(:xpath, "//a[@href='/public/builds/1/units']").click()
    page.find(:xpath, "//a[@href='/public/units/1/proposals/new']").click
    click_link "Histórico"
    page.find(:xpath, "//a[@href='/public/proposals/1/invoice']").click
    expect(page).to have_css("div.invoice h2.all-caps", text: 'Review your proposal!')
  end

  # it 'Destroy Proposal' do
  #   login_as(broker.user, :scope => :user)
  #   visit public_dashboards_path
  #   within "body" do
  #     all('div.panel.panel-default')[0].find('a').click
  #   end
  #   expect(page).to have_link('Delete')
  #   click_link 'Delete'
  #   expect(page).to have_content('Proposal was successfully destroyed.') 
  # end

  it 'Proposal Validates' do
    broker.user.make_current
    login_as(broker.user, :scope => :user)
    visit public_dashboards_path
    page.first(:xpath, "//a[@href='/public/builds/1/units']").click()
    page.find(:xpath, "//a[@href='/public/units/1/proposals/new']").click
    click_button 'Create'
    # save_and_open_page
    expect(page).to have_content("can't be blank")
  end

  # it "Can't update Proposal Analyzing" do
  #   broker.user.make_current
  #   login_as(broker.user, :scope => :user)
  #   proposal.book
  #   visit edit_public_proposal_path(proposal)
  #   fill_in("proposal_negociate", with: 'Proposal Negociate 2')    
  #   click_button 'Update'
  #   expect(page).to have_content("Proposal with restriction")
  # end

  # it 'Broker can Comment' do
  #   broker.user.make_current
  #   login_as(broker.user, :scope => :user)
  #   proposal.book
  #   visit public_dashboards_path
  #   within "body" do
  #     all('div.panel.panel-default')[0].find('a').click
  #   end
  #   click_link "Proposal's Broker"
  #   within "table.table" do # click_button "Edit"
  #     all('tbody tr')[0].find('a.btn.btn-primary').click
  #   end
  #   fill_in("proposal_comment", with: 'comment')    
  #   click_button 'Send'
  #   expect(page).to have_content('Comment was successfully updated.')
  # end

  it 'Proposal Redirect_if_Restriction' do
    broker.user.make_current
    proposal.accept
    broker2.user.make_current
    login_as(broker2.user, :scope => :user)
    visit public_dashboards_path
    page.first(:xpath, "//a[@href='/public/builds/1/units']").click()
    page.find(:xpath, "//a[@href='/public/units/1/proposals/new']").click
    expect(current_path).to match(public_build_units_path(build))
    expect(page).to have_css("span#notification-message", text: 'Restriction')
  end

  it  "Other Broker can not create Proposal's accepted" do
    broker2.user.make_current
    login_as(broker2.user, :scope => :user)
    proposal.accept
    visit edit_public_proposal_path(proposal)
    expect(page).to have_css("span#notification-message", text: 'Restriction')
  end
  
  it 'Proposal Redirect_if_Restriction to PurchaseSteps' do
    broker.user.make_current
    login_as(broker.user, :scope => :user)
    proposal.accept
    visit public_dashboards_path
    page.first(:xpath, "//a[@href='/public/builds/1/units']").click()
    page.find(:xpath, "//a[@href='/public/units/1/proposals/new']").click
    expect(current_path).to match(public_purchase_steps_path(proposal))
  end

end