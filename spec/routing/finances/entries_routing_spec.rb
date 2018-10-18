require "rails_helper"

RSpec.describe Finances::EntriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/finances/entries").to route_to("finances/entries#index")
    end

    it "routes to #new" do
      expect(:get => "/finances/entries/new").to route_to("finances/entries#new")
    end

    it "routes to #show" do
      expect(:get => "/finances/entries/1").to route_to("finances/entries#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/finances/entries/1/edit").to route_to("finances/entries#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/finances/entries").to route_to("finances/entries#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/finances/entries/1").to route_to("finances/entries#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/finances/entries/1").to route_to("finances/entries#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/finances/entries/1").to route_to("finances/entries#destroy", :id => "1")
    end

  end
end
