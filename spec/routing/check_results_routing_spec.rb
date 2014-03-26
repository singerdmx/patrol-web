require "spec_helper"

describe CheckResultsController do
  describe "routing" do

    it "routes to #index" do
      get("/check_results").should route_to("check_results#index")
    end

    it "routes to #new" do
      get("/check_results/new").should route_to("check_results#new")
    end

    it "routes to #show" do
      get("/check_results/1").should route_to("check_results#show", :id => "1")
    end

    it "routes to #edit" do
      get("/check_results/1/edit").should route_to("check_results#edit", :id => "1")
    end

    it "routes to #create" do
      post("/check_results").should route_to("check_results#create")
    end

    it "routes to #update" do
      put("/check_results/1").should route_to("check_results#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/check_results/1").should route_to("check_results#destroy", :id => "1")
    end

  end
end
