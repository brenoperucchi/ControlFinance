# save_and_open_page
require 'rails_helper'

RSpec.describe "Admin Mailers"  do
  let!(:store) { FactoryGirl.create(:store) }
  let!(:person) { FactoryGirl.create(:person, :admin, store: store)}
  let!(:admin) { FactoryGirl.create(:user, :admin, userable: person)}
  let!(:build) { FactoryGirl.create(:build, store: store)}
  let!(:unit) { FactoryGirl.create(:unit, builder:build)}
  let!(:broker) { FactoryGirl.create(:broker, :default, store: store)}
  let!(:proposal) { FactoryGirl.create(:proposal, unit: unit, broker: broker)}
  let!(:proposal2) { FactoryGirl.create(:proposal, unit: unit, broker: FactoryGirl.create(:broker, :second))}

  it 'Send a Price List' do
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

  it 'Price List with present validate' do
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