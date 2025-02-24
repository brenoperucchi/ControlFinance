# save_and_open_page
require 'rails_helper'

RSpec.describe "Admin Brokers" do
  let!(:store) { FactoryBot.create(:store) }
  let!(:person) { FactoryBot.create(:person, :admin, store: store)}
  let!(:admin) { FactoryBot.create(:user, :admin, userable: person, store: store)}
  let!(:build) { FactoryBot.create(:build, store: store)}
  let!(:unit) { FactoryBot.create(:unit, builder:build)}
  let!(:broker) { FactoryBot.create(:broker, :default, store:store)}
  let!(:proposal) { FactoryBot.create(:proposal, unit: unit, broker: broker)}
  let!(:proposal2) { FactoryBot.create(:proposal, unit: unit, broker: FactoryBot.create(:broker, :second))}


  it 'Access Admin Brokers' do
    admin.make_current
    login_as(admin, :scope => :user)
    visit admin_builds_path
    click_link('Brokers')
    expect(page).to have_text('Brokers')
  end

  it 'Create New Broker' do
    admin.make_current
    login_as(admin, :scope => :user)
    visit admin_brokers_path
    click_link('new')
    expect(page).to have_text('New Broker')
    fill_in('broker_name', with:'broker name')
    select('PENDING', from: 'broker_state')
    fill_in('broker_user_attributes_email', with:'broker@email.com')
    click_button 'Create Broker'
    expect(page).to have_text('broker was successfully created.')
  end

  it 'Update a Broker' do
    admin.make_current
    login_as(admin, :scope => :user)
    visit admin_brokers_path
    click_link('Edit')
    expect(page).to have_text('Edit')
    fill_in('broker_name', with:'broker change')
    select('APPROVED', from: 'broker_state')
    fill_in('broker_user_attributes_email', with:'broker@change.com')
    click_button 'Update Broker'
    expect(page).to have_text('APPROVED')
  end

  it 'Destroy a Broker' do
    admin.make_current
    login_as(admin, :scope => :user)
    visit admin_brokers_path
    click_link('Delete')
    expect(page).to have_text('broker was successfully destroyed.')
  end

  it 'Validate Presense' do
    admin.make_current
    login_as(admin, :scope => :user)
    visit admin_brokers_path
    click_link('Edit')
    expect(page).to have_text('Edit')
    fill_in('broker_name', with:'broker change')
    select('APPROVED', from: 'broker_state')
    fill_in('broker_user_attributes_email', with:'')
    click_button 'Update Broker'
    expect(page).to have_text("can't be blank")
  end

  it 'Validate Uniqueness' do
    admin.make_current
    login_as(admin, :scope => :user)
    visit admin_brokers_path
    click_link('new')
    expect(page).to have_text('New Broker')
    fill_in('broker_name', with:'broker name')
    select('PENDING', from: 'broker_state')
    fill_in('broker_user_attributes_email', with:'broker@email.com')
    click_button 'Create Broker'
    admin.make_current
    login_as(admin, :scope => :user)
    visit admin_brokers_path
    click_link('new')
    expect(page).to have_text('New Broker')
    fill_in('broker_name', with:'broker name')
    select('PENDING', from: 'broker_state')
    fill_in('broker_user_attributes_email', with:'broker@email.com')
    click_button 'Create Broker'
    expect(page).to have_text("has already been taken")
  end

end
