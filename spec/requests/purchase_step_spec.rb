require 'rails_helper'

RSpec.describe "PublicProposals" do
  let!(:broker) { FactoryGirl.create(:broker, :default)}
  let!(:build) { FactoryGirl.create(:build)}
  let!(:unit) { FactoryGirl.create(:unit, builder:build)}
  let!(:proposal) { FactoryGirl.create(:proposal, unit: unit, broker: broker)}
  let!(:buyer) { FactoryGirl.create(:buyer, proposal: proposal)}

  it 'Accepted Redirect to PurchaseStep Proposal' do
    broker.user.make_current
    login_as(broker.user, :scope => :user)
    proposal.accept
    visit public_builds_path
    click_link('Proposal')
    expect(page).to have_text('Proposal') 
    expect(page).to have_text('Buyer') 
    expect(page).to have_text('Document') 
  end

  it 'PurchaseStep Buyer' do
    broker.user.make_current
    login_as(broker.user, :scope => :user)
    proposal.accept
    visit public_builds_path
    click_link('Proposal')
    click_button('Update Proposal')
    expect(page).to have_css('li.tab-current', text: 'Buyer') 
    # save_and_open_page
  end

  it 'PurchaseStep Document' do
    broker.user.make_current
    login_as(broker.user, :scope => :user)
    proposal.accept
    visit public_builds_path
    click_link('Proposal')
    click_button('Update Proposal')
    click_button('Update Proposal')
    expect(page).to have_css('li.tab-current', text: 'Document') 
  end

end