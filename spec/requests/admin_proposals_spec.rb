require 'rails_helper'

RSpec.describe "Admin Proposals" do
  let!(:store) { FactoryGirl.create(:store) }
  let!(:person) { FactoryGirl.create(:person, :admin, store: store)}
  let!(:admin) { FactoryGirl.create(:user, :admin, userable: person)}
  let!(:build) { FactoryGirl.create(:build, store: store)}
  let!(:unit) { FactoryGirl.create(:unit, builder:build)}
  let!(:broker) { FactoryGirl.create(:broker, :default, store: store)}
  let!(:proposal) { FactoryGirl.create(:proposal, unit: unit, broker: broker)}
  let!(:proposal2) { FactoryGirl.create(:proposal, unit: unit, broker: FactoryGirl.create(:broker, :second))}

  it 'New Proposal by Admin' do
    admin.make_current
    login_as(admin, :scope => :user)
    visit admin_builds_path
    click_link('Proposals')
    click_link('New Proposal')
    fill_in("admin_proposal_negociate", with: 'Proposal Negociate')    
    fill_in("admin_proposal_value", with: '100')    
    fill_in("admin_proposal_due_at", with: Date.today.strftime("%d/%m/%Y"))    
    select('Broker 1', :from => 'admin_proposal_broker_id')
    click_button 'Create'
    expect(page).not_to have_text('Please review the problems below:')
    expect(page).to have_text('Proposal was successfully created.')
  end

  it "Change Proposal's State" do
    admin.make_current
    login_as(admin, :scope => :user)
    visit admin_builds_path
    click_link('Proposals')
    page.find(:xpath, "//a[@href='/admin/proposals/1/edit']").click
    select('book', :from => 'admin_proposal_status')
    click_button('Update')
    expect(page).to have_field('admin_proposal_status', with: 'booked')
    # save_and_open_page
  end

  # it 'Can Comment on Proposal' do
  #   admin.make_current
  #   login_as(admin, :scope => :user)
  #   proposal.book
  #   expect(proposal.state).to match('booked')
  #   visit edit_admin_proposal_path(proposal)
  #   fill_in("admin_proposal_comment", with: 'comment')    
  #   click_button 'Send'
  #   expect(page).to have_text('Comment was successfully updated.')
  # end

  it 'Admin can send Email Proposal' do
    admin.make_current
    login_as(admin, :scope => :user)
    proposal.book
    expect(proposal.state).to match('booked')
    visit admin_builds_path
    click_link('Request Proposal Email')
    # save_and_open_page
  end

  it 'State can not change if already had accepted' do
    admin.make_current
    proposal.accept
    expect(proposal.state).to match('accepted')
    login_as(admin, :scope => :user)
    visit edit_admin_proposal_path(proposal2)
    select('accepted', :from => 'admin_proposal_status')
    click_button('Update')
    expect(page).not_to have_select('admin_proposal_status', selected: 'accepted')
    expect(page).not_to have_text('Proposal was successfully updated.')
  end

  it 'State can not change if already had closed' do
    admin.make_current
    proposal.book
    expect(proposal.state).to match('booked')
    proposal.close
    expect(proposal.state).to match('closed')
    login_as(admin, :scope => :user)
    visit edit_admin_proposal_path(proposal2)
    select('closed', :from => 'admin_proposal_status')
    click_button('Update')
    expect(page).not_to have_select('admin_proposal_status', selected: 'closed')
    expect(page).not_to have_text('Proposal was successfully updated.')
  end

  it 'State to accepted can not change if already had closed' do
    admin.make_current
    proposal.book
    expect(proposal.state).to match('booked')
    proposal.accept
    expect(proposal.state).to match('accepted')
    proposal.close
    expect(proposal.state).to match('closed')
    login_as(admin, :scope => :user)
    visit edit_admin_proposal_path(proposal2)
    select('accepted', :from => 'admin_proposal_status')
    click_button('Update')
    expect(page).to have_select('admin_proposal_status', selected: 'pending')
    expect(page).not_to have_text('Proposal was successfully updated.')
  end

  it 'State closed can change to pending' do
    admin.make_current
    proposal.book
    expect(proposal.state).to match('booked')
    proposal.accept
    expect(proposal.state).to match('accepted')
    proposal.close
    expect(proposal.state).to match('closed')
    login_as(admin, :scope => :user)
    visit edit_admin_proposal_path(proposal)
    select('pending', :from => 'admin_proposal_status')
    click_button('Update')
    expect(page).to have_select('admin_proposal_status', selected: 'pending')
    expect(page).to have_text('Proposal was successfully updated.')
    visit admin_builds_path
  end

end