require 'rails_helper'

RSpec.describe "finances/entries/new", type: :view do
  before(:each) do
    assign(:finances_entry, Finances::Entry.new())
  end

  it "renders new finances_entry form" do
    render

    assert_select "form[action=?][method=?]", finances_entries_path, "post" do
    end
  end
end
