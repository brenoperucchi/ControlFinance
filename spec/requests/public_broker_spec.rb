# save_and_open_page
require 'rails_helper'

RSpec.describe "PublicBroker", focus: true do
  let!(:store) { FactoryGirl.create(:store) }

  it "Create New Broker" do
    # Capybara.asset_host = "http://#{store.url}.localhost:3000"
    # Capybara.app_host = 'http://eloe.localhost:3000'
    visit new_public_broker_url(host: 'eloe.localhost:3000')
    # show_page(store)
    save_and_open_page
    fill_in("broker_name", with: 'Broker 1')
    fill_in("broker_irs_id", with: 'IrsID')
    fill_in("broker_company", with: 'Company')
    fill_in("broker_address", with: 'Address, 123')
    fill_in("broker_phone", with: '55-5555-5555')
    fill_in("broker_company_irs_id", with: 'IrsId Company')
    choose 'choice2'
    choose 'choice4'
    choose 'choice6'
    choose 'choice8'
    choose 'choice10'
    click_button "Create a new account"
    expect(page).to have_content("Broker was successfully created.")
    expect(current_path).to match(contract_public_broker_path(1))
  end

  it "Validate New Broker" do
    visit new_public_broker_path
    click_button "Create a new account"
    expect(page).to have_content("can't be blank", count: 6)
  end
end