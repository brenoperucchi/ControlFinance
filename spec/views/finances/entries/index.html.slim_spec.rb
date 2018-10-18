require 'rails_helper'

RSpec.describe "finances/entries/index", type: :view do
  before(:each) do
    assign(:finances_entries, [
      Finances::Entry.create!(),
      Finances::Entry.create!()
    ])
  end

  it "renders a list of finances/entries" do
    render
  end
end
