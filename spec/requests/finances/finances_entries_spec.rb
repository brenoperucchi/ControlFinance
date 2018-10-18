require 'rails_helper'

RSpec.describe "Finances::Entries", type: :request do
  describe "GET /finances_entries" do
    it "works! (now write some real specs)" do
      get finances_entries_path
      expect(response).to have_http_status(200)
    end
  end
end
