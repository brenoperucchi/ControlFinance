require 'rails_helper'

RSpec.describe "finances/entries/edit", type: :view do
  before(:each) do
    @finances_entry = assign(:finances_entry, Finances::Entry.create!())
  end

  it "renders the edit finances_entry form" do
    render

    assert_select "form[action=?][method=?]", finances_entry_path(@finances_entry), "post" do
    end
  end
end
