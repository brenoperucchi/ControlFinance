require 'rails_helper'

RSpec.describe "PublicProposals" do
  let!(:broker) { FactoryGirl.create(:broker, :default)}
  let!(:broker2) { FactoryGirl.create(:broker, :second)}
  let!(:build) { FactoryGirl.create(:build)}
  let!(:unit) { FactoryGirl.create(:unit, builder:build)}
  let!(:proposal) { FactoryGirl.create(:proposal, unit: unit, broker: broker)}
  let!(:proposal2) { FactoryGirl.create(:proposal, unit: unit, broker: broker2)}

  before(:each) do
  end

  it 'Make Proposal' do
    visit public_builds_path
    click_link('Proposal')
    fill_in("proposal_negociate", with: 'Proposal Negociate')    
    fill_in("proposal_value", with: '100')    
    fill_in("proposal_broker_attributes_name", with: 'name')    
    fill_in("proposal_broker_attributes_user_attributes_email", with: 'email@test.com')
    click_button 'Create'
    expect(page).not_to have_text('Please review the problems below:')
    expect(page).to have_text('Proposal was successfully created.')
    
  end

  it 'Proposal Already Signed' do
    broker.user.make_current
    login_as(broker.user, :scope => :user)
    visit public_builds_path
    within "body" do 
      all('div.panel.panel-default')[0].find('a').click
    end
    expect(page).to have_text("Proposal")
  end

  it 'Edit and Update Proposal Broker' do
    login_as(broker.user, :scope => :user)
    visit public_builds_path
    page.find(:xpath, "//a[@href='/public/units/1/proposals/new']").click
    click_link "Proposal's Broker"
    page.find(:xpath, "//a[@href='/public/proposals/1/edit']").click
    fill_in("proposal_negociate", with: 'negociate 2')    
    fill_in("proposal_value", with: '1000')    
    click_button 'Update Proposal'
    expect(page).to have_text('Proposal was successfully updated.')
  end

  # it 'Destroy Proposal' do
  #   login_as(broker.user, :scope => :user)
  #   visit public_builds_path
  #   within "body" do
  #     all('div.panel.panel-default')[0].find('a').click
  #   end
  #   expect(page).to have_link('Delete')
  #   click_link 'Delete'
  #   expect(page).to have_text('Proposal was successfully destroyed.') 
  # end

  it 'Proposal Validates' do
    visit public_builds_path
    click_link('Proposal')
    fill_in("proposal_negociate", with: 'Proposal Negociate')    
    click_button 'Create'
    expect(page).to have_text("can't be blank")
  end

  it "Can't update Proposal Analyzing" do
    broker.user.make_current
    login_as(broker.user, :scope => :user)
    proposal.book
    visit edit_public_proposal_path(proposal)
    fill_in("proposal_negociate", with: 'Proposal Negociate 2')    
    click_button 'Update'
    expect(page).to have_text("Proposal with restriction")
  end

  # it 'Broker can Comment' do
  #   broker.user.make_current
  #   login_as(broker.user, :scope => :user)
  #   proposal.book
  #   visit public_builds_path
  #   within "body" do
  #     all('div.panel.panel-default')[0].find('a').click
  #   end
  #   click_link "Proposal's Broker"
  #   within "table.table" do # click_button "Edit"
  #     all('tbody tr')[0].find('a.btn.btn-primary').click
  #   end
  #   fill_in("proposal_comment", with: 'comment')    
  #   click_button 'Send'
  #   expect(page).to have_text('Comment was successfully updated.')
  # end

  it 'Proposal Redirect_if_Restriction to Builds_Path' do
    broker.user.make_current
    proposal.accept
    broker2.user.make_current
    login_as(broker2.user, :scope => :user)
    visit public_builds_path
    click_link('Proposal')
    expect(current_path).to match(public_builds_path)
    expect(page).to have_text('Proposal with restriction')
  end

  it  "Other Broker can not create Proposal's accepted" do
    broker2.user.make_current
    login_as(broker2.user, :scope => :user)
    proposal.accept
    visit edit_public_proposal_path(proposal)
    expect(page).to have_text('Proposal with restriction')
  end

  it 'Proposal Redirect_if_Restriction without LOGIN to Builds_Path' do
    broker2.user.make_current
    proposal.accept
    visit public_builds_path
    click_link('Proposal')
    expect(page).to have_text('Proposal with restriction')
  end
  
  it 'Proposal Redirect_if_Restriction to PurchaseSteps' do
    broker.user.make_current
    login_as(broker.user, :scope => :user)
    proposal.accept
    visit public_builds_path
    click_link('Proposal')
    expect(current_path).to match(public_purchase_steps_path(proposal))
  end

  it 'New Proposal without User Authentication' do
    visit public_builds_path
    click_link('Proposal')
    expect(current_path).to match(new_public_unit_proposal_path(unit))
  end


end