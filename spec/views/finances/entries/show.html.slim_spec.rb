require 'rails_helper'

RSpec.describe "finances/entries/show", type: :view do
  before(:each) do
    @finances_entry = assign(:finances_entry, Finances::Entry.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
