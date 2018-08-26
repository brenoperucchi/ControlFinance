# save_and_open_page
require 'rails_helper'

RSpec.describe "PublicBroker"  do
  let!(:store) { FactoryBot.create(:store) }
  let(:broker) { FactoryBot.create(:broker, :default, store: store)}

  it "Create New Broker" do
    visit new_public_broker_url(host: 'eloe.localhost:3000')
    fill_in("broker_name", with: 'Broker 1')
    fill_in("broker_user_attributes_email", with: 'broker@broker.com')
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
    choose 'choice12'
    click_button "FINISH SIGN IN"
    expect(page).to have_content("Broker was successfully created.")
    expect(current_path).to match(revise_public_broker_path(1))
  end

  it "Print Contract" do
    visit revise_public_broker_path(broker)
    login_as(broker.user, :scope => :user)
    page.first(:xpath, "//a[@href='/public/brokers/1/contract']").click()
    expect(page).to have_css('em#contract_title', text: 'AUTORIZAÇÃO PARA PRESTAÇÃO DE SERVIÇOS DE INTERMEDIAÇÃO IMOBILIÁRIA SEM EXCLUSIVIDADE.')
  end

  it "Send File" do
    visit revise_public_broker_path(broker)
    login_as(broker.user, :scope => :user)
    page.find(:xpath, "//a[@href='/public/brokers/1/assets']").click()
    expect(page).to have_content('Files')
  end

end
