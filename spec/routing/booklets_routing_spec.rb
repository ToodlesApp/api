require "rails_helper"

RSpec.describe BookletsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/booklets").to route_to("booklets#index")
    end

    it "routes to #new" do
      expect(:get => "/booklets/new").to route_to("booklets#new")
    end

    it "routes to #show" do
      expect(:get => "/booklets/1").to route_to("booklets#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/booklets/1/edit").to route_to("booklets#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/booklets").to route_to("booklets#create")
    end

    it "routes to #update" do
      expect(:put => "/booklets/1").to route_to("booklets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/booklets/1").to route_to("booklets#destroy", :id => "1")
    end

  end
end
